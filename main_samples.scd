s.boot;
o = s.options;
o.memSize = 1000000;
o.blockSize = 128;


(

~samplePath = thisProcess.nowExecutingPath.dirname +/+ "sounds/808/"; //MAC
//~samplePath = Platform.resourceDir +/+ "sounds/808/"; //Windows

TempoClock.tempo=2.3;
d = Dictionary.new;

~synapseSend = NetAddr.new("127.0.0.1", 12345);    // create the NetAddr
~synapseReceive = NetAddr.new("127.0.0.1", 12346);    // create the NetAddr
~wekinator = NetAddr.new("127.0.0.1", 6448); //indirizzo parametri regressione per cutoff filtro
~wekinator1 = NetAddr.new("127.0.0.1", 6449); //indirizzo parametri regressione room&mix riverbero
~wekinator2 = NetAddr.new("127.0.0.1", 6450); //indirizzo parametri classificazione stato filtro
~wekinator3 = NetAddr.new("127.0.0.1", 6451); //indirizzo parametri classificazione stato riverbero
~processing = NetAddr("127.0.0.1", 12001);

~b1 = Bus.audio(s, 2);

//0 = sample launch mode, 1 = effect mode
~state1 = 1;
~state2 = 1;

d.add(\808 ->
	PathName(~samplePath).entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
});)

)

(

//KICK

SynthDef.new(\kick, {
	arg rate = 1, amp=1, decayTime = 0, outBus = 0;
	var sig, env;
	sig = PlayBuf.ar(1,0, BufRateScale.ir(0)*rate, doneAction: 2);
	env = EnvGen.ar(Env.adsr(0,decayTime,0,1));
	sig = sig * env;
	sig = sig * amp;
	Out.ar(outBus, Pan2.ar(sig, 0, 1));
}).add;


//CLOSED HAT

SynthDef.new(\hatclosed, {
	arg rate = 1, amp=1, pan=0, outBus = 0;
	var sig;
	sig = PlayBuf.ar(1,2, BufRateScale.ir(2)*rate, doneAction: 2);
	sig = sig * amp;
	Out.ar(outBus, Pan2.ar(sig, pan, 1));
}).add;


//CLAP

SynthDef.new(\clap, {
	arg rate = 1, amp=1, decayTime = 1, outBus = 0;
	var sig, env;
	sig = PlayBuf.ar(1,4, BufRateScale.ir(4)*rate, doneAction: 2);
	env = EnvGen.ar(Env.adsr(0,decayTime,0,1));
	sig = sig * env;
	sig = sig * amp;
	Out.ar(outBus, Pan2.ar(sig, 0, 1));
}).add;


//SNARE

SynthDef.new(\snare, {
	arg rate = 1, amp=1, decayTime=0, outBus = 0;
	var sig, env;
	sig = PlayBuf.ar(1,15, BufRateScale.ir(15)*rate, doneAction: 2);
	env = EnvGen.ar(Env.adsr(0,decayTime,0,1));
	sig = sig * env;
	sig = sig * amp;
	Out.ar(outBus, Pan2.ar(sig, 0, 1));
}).add;


//LOWPASS FILTER

SynthDef.new(\filter, {
	arg outBus, inBus, pan = 0, cutoff = 20000;
	var input, output;
	input = In.ar(inBus,2);
	output = LPF.ar(input, cutoff.lag(0.05), 1, 0);
	Out.ar(outBus, Pan2.ar(output, 0, 1));
}).add;


SynthDef(\reverb, { arg outBus = 0, inBus , pan = 0, mix = 0, room = 1;
	var input,out;

	input = In.ar(inBus, 2);

	out = FreeVerb.ar(input,mix:mix,room:room);
	Out.ar(outBus, Pan2.ar(out, pan))
}).add;


x = Synth.new(\filter, [\inBus, ~b1]);
y = Synth.after(x,\reverb);

)


(

Pdef(
	\kickpattern,
    Pbind(
		\instrument, \kick,
		\dur, Pseq([2], inf),
		\decayTime, 0.2,
		\rate, 1,
		\amp, 1,
		\outBus, ~b1,
		\x, Pfunc ({ |evt|
			if(evt.isRest == false){
				~processing.sendMsg("/kick", \play);
			}{
				~processing.sendMsg("/nokick", \play);
			}
		})
	);
);



Pdef(
	\hatclosedpattern,
	Pbind(
		\instrument, \hatclosed,
		\dur, Pseq([0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.125, 0.125,
			0.125, 0.125, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 0.5, 0.5, 0.5, 0.5, 0.3333, 0.3333,
			0.3334], inf),
		\rate, 1,
		\amp, Pseq([0.1, 0.3], inf),
		\pan, Pwhite(-0.2, 0.2, inf),
		\outBus, ~b1,
		\x, Pfunc ({ |evt|
			if(evt.isRest == false){
				~processing.sendMsg("/hatclosed", \play);
			}{
				~processing.sendMsg("/nohatclosed", \play);
			}
		})
	);
);


Pdef(
	\clappattern,
	Pbind(
		\instrument, \clap,
		\dur, Pseq([Rest(2), 1, Rest(3), 1, Rest(0.25), 0.75], inf),
		\decayTime, 0.4,
		\rate, 2,
		\amp, 1,
		\outBus, ~b1,
		\x, Pfunc ({ |evt|
			if(evt.isRest == false){
				~processing.sendMsg("/clap", \play);
			}{
				~processing.sendMsg("/noclap", \play);
			}
		})
	);
);

Pdef(
	\snarepattern,
	Pbind(
		\instrument, \snare,
		\dur, Pseq([Rest(2), 1, Rest(1)], inf),
		\decayTime, 1,
		\rate, 1.5,
		\amp,  1,
		\outBus, ~b1,
		\x, Pfunc ({ |evt|
			if(evt.isRest == false){
				~processing.sendMsg("/snare", \play);
			}{
				~processing.sendMsg("/nosnare", \play);
			}
		})
	)
);
)

s.plotTree

(

//chiede a synapse posizione mano destra
~trackRH = Task.new({
	{
		~synapseReceive.sendMsg("/righthand_trackjointpos", 1);
		~synapseReceive.sendMsg("/lefthand_trackjointpos", 1);

		2.wait;
	}.loop;
}).play;


//traccia eventi mano destra synapse
OSCdef.new(
	\trackRH,
	{
		arg msg;
		if(msg[1] == \forward)
		{
			if(Pdef(\kickpattern).isPlaying == false)
			    {
			        "PLAY".postln;
					msg.postln;
					Pdef(\kickpattern).play(quant:4);
			    }{
				    "STOP".postln;
				    Pdef(\kickpattern).stop;
			    };
			}{
			    //do nothing
			};
		if(msg[1] == \up)
			{
			if(Pdef(\clappattern).isPlaying == false)
			    {
			        "PLAY".postln;
					msg.postln;
					Pdef(\clappattern).play(quant:4);
			    }{
				    "STOP".postln;
				    Pdef(\clappattern).stop;
			    };
			}{
			    //do nothing
			};
	},
	'/righthand',
	nil,
	12345
);

//traccia eventi mano sinistra synapse
OSCdef.new(
	\trackLH,
	{
		arg msg;
		if(msg[1] == \forward)
			{
			if(Pdef(\hatclosedpattern).isPlaying == false)
			    {
			        "PLAY".postln;
					msg.postln;
					Pdef(\hatclosedpattern).play(quant:4);
			    }{
				    "STOP".postln;
				    Pdef(\hatclosedpattern).stop;
			    };
			}{
			    //do nothing
			};
		if(msg[1] == \up)
			{
			if(Pdef(\snarepattern).isPlaying == false)
			    {
			        "PLAY".postln;
					msg.postln;
				Pdef(\snarepattern).play(quant:4);
			    }{
				    "STOP".postln;
				    Pdef(\snarepattern).stop;
			    };
			}{
			    //do nothing
			};
	},
	'/lefthand',
	nil,
	12345
);


//OSCdef per ricevere pacchetti da synapse e mandarli a wekinator (mano destra)
OSCdef.new(
	\synapseReceiverFilterParam,
	{
		arg msg;
		~wekinator.sendMsg('/wek/righthand_pos_body', msg[1], msg[2], msg[3]);
	},
	'/righthand_pos_body',
	nil,
	12345
);

//OSCdef per ricevere pacchetti da synapse e mandarli a wekinator (mano destra)
OSCdef.new(
	\synapseReceiverReverbParam,
	{
		arg msg;
		~wekinator1.sendMsg('/wek/lefthand_pos_body', msg[1], msg[2], msg[3]);
	},
	'/lefthand_pos_body',
	nil,
	12345
);

OSCdef.new(
	\wekiReceiverRight,
	{
		arg msg;
		//msg.postln;
		if(~state1 ==1){
			x.set(\cutoff, msg[1].linexp(0,1,100,20000));
		}{
			//do nothing
		};
	},
	'/wek/cutoff_freq',
	nil,
	12000
);


//OSCdef per ricevere cutoff freq da wekinator
OSCdef.new(
	\wekiReceiverLeft,
	{
		arg msg;
		//msg.postln;
		if(~state2 ==1){
			y.set(\mix, msg[1], \room, msg[2]);
			~processing.sendMsg('/reverb_values',msg[1],msg[2]);
		}{
			//do nothing
		};
	},
	'/wek/reverb_values',
	nil,
	12000
);

OSCdef.new(
	\synapseReceiverFilterState,
	{
		arg msg;
		~wekinator2.sendMsg('/wek/righthand_height', msg[2]);
	},
	'/righthand_pos_body',
	nil,
	12345
);

OSCdef.new(
	\synapseReceiverDelayState,
	{
		arg msg;
		~wekinator3.sendMsg('/wek/lefthand_height', msg[2]);
	},
	'/lefthand_pos_body',
	nil,
	12345
);

//switcha effect mode wekinator
OSCdef.new(
	\enterFilterState,
	{
		arg msg;
		msg.postln;
		~state1 = msg[1];
	},
	'/wek/change_filter_state',
	nil,
	12000
);

OSCdef.new(
	\enterReverbState,
	{
		arg msg;
		msg.postln;
		~state2 = msg[1];
	},
	'/wek/change_reverb_state',
	nil,
	12000
);

)

r.play;

~synapseSend.sendMsg("/righthand", \forward);
~synapseSend.sendMsg("/righthand", \up);
~synapseSend.sendMsg("/lefthand", \forward);
~synapseSend.sendMsg("/lefthand", \up);

Pdef(\clappattern).play(quant:4);
Pdef(\clappattern).stop;

Tdef(\kickpattern).play(quant:4);


s.plotTree
ServerMeter.new(s, 0, 2);

{SinOsc.ar(300+(200*Latch.ar(SinOsc.ar(13.3), Impulse.ar(10))))*0.2}.stop



