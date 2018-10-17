s.boot;

(

//~samplePath = thisProcess.nowExecutingPath.dirname +/+ "sounds/808/"; //MAC
~samplePath = Platform.resourceDir +/+ "sounds/808/"; //Windows

TempoClock.tempo=130/60;
d = Dictionary.new;

~synapseSend = NetAddr.new("127.0.0.1", 12345);    // create the NetAddr
~synapseReceive = NetAddr.new("127.0.0.1", 12346);    // create the NetAddr
// ~wekinator = NetAddr.new("127.0.0.1", 6448); //indirizzo parametri regressione per cutoff filtro
// ~wekinator1 = NetAddr.new("127.0.0.1", 6449); //indirizzo parametri regressione room&mix riverbero
~processing = NetAddr("127.0.0.1", 12001);

~b1 = Bus.audio(s, 2);

//0 = sample launch mode, 1 = effect mode
~state = 1;

d.add(\808 ->
	PathName(~samplePath).entries.collect({
		arg sf;
		Buffer.read(s, sf.fullPath);
});)

)

(

//Clips synth definitions

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

SynthDef.new(\sinegrain,
    { arg out=0, freq=440, sustain=0.02;
        var env;
        env = EnvGen.kr(Env.perc(0.001, sustain), 1, doneAction: Done.freeSelf);
        Out.ar(out, SinOsc.ar(freq, 0, env * 0.1))
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

)

(

//Pattern definitions

Pdefn(\dur1,Pseq([2],inf));

Pdef(
	\pattern1,
    Pbind(
		\instrument, Pfunc({ |e| e.instrument}),
		\dur, Pdefn(\dur1),
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

Pdefn(\dur2,Pseq([0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.125, 0.125,
			0.125, 0.125, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 0.5, 0.5, 0.5, 0.5, 0.3333, 0.3333,
			0.3334], inf));

Pdef(
	\pattern2,
	Pbind(
		\instrument, Pfunc({ |e| e.instrument}),
		\dur, Pdefn(\dur2),
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

Pdefn(\dur3,Pseq([Rest(2), 1, Rest(3), 1, Rest(0.25), 0.75], inf));

Pdef(
	\pattern3,
	Pbind(
		\instrument, Pfunc({ |e| e.instrument}),
		\dur, Pdefn(\dur3),
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

Pdefn(\dur4,Pseq([Rest(2), 1, Rest(1)], inf));

Pdef(
	\pattern4,
	Pbind(
		\instrument, Pfunc({ |e| e.instrument}),
		\dur, Pdefn(\dur4),
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

(

//Filters instantiation and instrument default initialization for each pattern

x = Synth.new(\filter, [\inBus, ~b1]);
y = Synth.after(x,\reverb);

Pdef(\pattern1).set(\instrument,\kick);
Pdef(\pattern2).set(\instrument,\hatclosed);
Pdef(\pattern3).set(\instrument,\clap);
Pdef(\pattern4).set(\instrument,\snare);
)

(

//OSC packets functions

//Keep alive packets (sent for keeping Synapse sending OSC messages with events and tracking parameters)
~trackRH = Task.new({
	{
		~synapseReceive.sendMsg("/righthand_trackjointpos", 1);
		~synapseReceive.sendMsg("/lefthand_trackjointpos", 1);

		2.wait;
	}.loop;
}).play;


//OSC functions for responding to the right hand's events (play/stop pattern 1 and pattern 3)
OSCdef.new(
	\trackRH,
	{
		arg msg;
		if(msg[1] == \forward)
		{
			if(Pdef(\pattern1).isPlaying == false)
			    {
			        "PLAY".postln;
					msg.postln;
					Pdef(\pattern1).play(quant:4);
				    ~processing.sendMsg("/seq_kick", \play);
			    }{
				    "STOP".postln;
				    Pdef(\pattern1).stop;
				   ~processing.sendMsg("/seq_kick", \stop);
			};
		}{
			//do nothing
		};
		if(msg[1] == \up)
		{
			if(Pdef(\pattern3).isPlaying == false)
			    {
			        "PLAY".postln;
					msg.postln;
					Pdef(\pattern3).play(quant:4);
					~processing.sendMsg("/seq_clap", \play);
			    }{
				    "STOP".postln;
				    Pdef(\pattern3).stop;
				    ~processing.sendMsg("/seq_clap", \stop);
			};
		}{
			//do nothing
		};
	},
	'/righthand',
	nil,
	12345
);

//OSC functions for responding to the left hand's events (play/stop pattern 2 and pattern 4)
OSCdef.new(
	\trackLH,
	{
		arg msg;
		if(msg[1] == \forward)
		{
			if(Pdef(\pattern2).isPlaying == false)
			    {
			        "PLAY".postln;
					msg.postln;
					Pdef(\pattern2).play(quant:4);
				    ~processing.sendMsg("/seq_hatclosed", \play);
			    }{
				    "STOP".postln;
				    Pdef(\pattern2).stop;
				    ~processing.sendMsg("/seq_hatclosed", \stop);
			};
		}{
			//do nothing
		};
		if(msg[1] == \up)
		{
			if(Pdef(\pattern4).isPlaying == false)
			    {
			        "PLAY".postln;
					msg.postln;
				    Pdef(\pattern4).play(quant:4);
					~processing.sendMsg("/seq_snare", \play);
			    }{
				    "STOP".postln;
				    Pdef(\pattern4).stop;
				    ~processing.sendMsg("/seq_snare", \stop);
			};
		}{
			//do nothing
		};
	},
	'/lefthand',
	nil,
	12345
);


/*//OSCdef per ricevere pacchetti da synapse e mandarli a wekinator (mano destra)
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
		~wekinator1.sendMsg('/wek/lefthand_pos_body', msg[1], msg[2]);
	},
	'/lefthand_pos_body',
	nil,
	12345
);*/

//OSC function for setting the low-pass filter cutoff frequence values received from Wekinator
OSCdef.new(
	\wekiReceiverRight,
	{
		arg msg;
		//msg.postln;
		if(~state ==1){
			x.set(\cutoff, msg[1].linexp(0,1,100,20000));
			~processing.sendMsg('/cutoff_value',msg[1]);
		}{
			//do nothing
		};
	},
	'/wek/cutoff_freq',
	nil,
	12000
);


//OSC function for setting the reverb room and mix values received from Wekinator
OSCdef.new(
	\wekiReceiverLeft,
	{
		arg msg;
		//msg.postln;
		if(~state ==1){
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

//OSC function for entering/exiting the effect mode through the touchOSC app
OSCdef.new(
	\enterEffectState,
	{
		arg msg;
		msg.postln;
		~state = msg[1];
	},
	'/effect_mode',
	nil,
	12000
);

)

//CLOCK PATTERN
t = Pdef(
	\tempoClock,
	Pbind(
		\dur, 1/4,
		\amp, 0,
		\x, Pfunc {
			~processing.sendMsg("/tempo", \tempo);
		}
	);
);

t.play(quant:4);
t.stop;



~synapseSend.sendMsg("/righthand", \forward);
~synapseSend.sendMsg("/righthand", \up);
~synapseSend.sendMsg("/lefthand", \forward);
~synapseSend.sendMsg("/lefthand", \up);

Pdef(\clappattern).play(quant:4);

Pdef(\pattern1).set(\instrument,\kick);
Pdef(\pattern2).set(\instrument,\hatclosed);
Pdefn(\dur3,Pseq([0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.125, 0.125,
			0.125, 0.125, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 0.5, 0.5, 0.5, 0.5, 0.3333, 0.3333,
	0.3334], inf));
Pdef(\pattern3).stop;
Pdefn(\dur3,Pseq([Rest(2), 1, Rest(3), 1, Rest(0.25), 0.75], inf));
Pdef(\pattern3).play(quant:4);

s.plotTree
ServerMeter.new(s, 0, 2);

{SinOsc.ar(300+(200*Latch.ar(SinOsc.ar(13.3), Impulse.ar(10))))*0.2}.stop



