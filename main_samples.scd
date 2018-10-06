s.boot;

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
	arg rate = 1, amp=1, decayTime = 0, outBus = 0;
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
	arg outBus, inBus, pan = 0, cutoff = 1000;
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

var b1 = Bus.audio(s, 2);
var b2 = Bus.audio(s,2);
x = Synth.new(\filter, [\inBus, b1]);
y = Synth.after(x,\reverb,);

Pdef(
	\kickpattern,
	Pbind(
		\instrument, \kick,
		\dur, Pseq([0.75, 0.75, 1, 0.75, 0.75], inf),
		\decayTime, Pseq([0.4, 0.4, 2, 0.4, 0.4], inf),
		\rate, Pseq([1, 1, 1, 1, 1, 1, 1, 1, 1, 1], inf),
		\amp, 1,
		\outBus, b1,
	);
);


Pdef(
	\hatclosedpattern,
	Pbind(
		\instrument, \hatclosed,
		\dur, Pseq([0.25], inf),
		\rate, Pwhite(0.9, 1, inf),
		\amp, Pseq([0.1, 0.2, 0.6, 0.6, 0.1, 0.2, 0.6, 0.6], inf),
		\pan, Pwhite(-0.5, 0.5, inf),
		\outBus, b1,
	);
);


Pdef(
	\clappattern,
	Pbind(
		\instrument, \clap,
		\dur, Pseq([1, 0.75, 1.25, 1], inf),
		\decayTime, 0.4,
		\rate, 2,
		\amp,  Pseq([0, 0.5, 0.7, 0.5], inf),
		\outBus, b1,
	);
);

Pdef(
	\snarepattern,
	Pbind(
		\instrument, \snare,
		\dur, Pseq([1], inf),
		\decayTime, 1,
		\rate, 1,
		\amp,  Pseq([0, 0.5], inf),
		\outBus, b1,
	)
);
)

(
d = Dictionary.new;
~synapseSend = NetAddr.new("127.0.0.1", 12345);    // create the NetAddr
~synapseReceive = NetAddr.new("127.0.0.1", 12346);    // create the NetAddr
~wekinator = NetAddr.new("127.0.0.1", 6448);
~wekinator1 = NetAddr.new("127.0.0.1", 6449);
~wekinator2 = NetAddr.new("127.0.0.1", 6450);
~wekinator3 = NetAddr.new("127.0.0.1", 6451);
~processing = NetAddr("127.0.0.1", 12001);

//0 = sample launch mode, 1 = effect mode
~state1 = 1;
~state2 = 1;

var samplePath = thisProcess.nowExecutingPath.dirname +/+ "sounds/808/"; //MAC
//var samplePath = Platform.resourceDir +/+ "sounds/808/"; //Windows

d.add(\808 ->
	PathName(samplePath).entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
});)

TempoClock.tempo=2;
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
			~processing.sendMsg("/kick", \play);
			if(Pdef(\kickpattern).isPlaying == false)
			    {
			        "PLAY".postln;
					msg.postln;
					Pdef(\kickpattern).play(quant:1);
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
					Pdef(\clappattern).play(quant:1);
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
					Pdef(\hatclosedpattern).play(quant:1);
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
					Pdef(\snarepattern).play(quant:1);
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
			y.set(\mix, msg[1], \room, msg[2])
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

b.sendMsg("/righthand", \forward);
b.sendMsg("/righthand", \up);
b.sendMsg("/lefthand", \forward);
b.sendMsg("/lefthand", \up);


s.plotTree
ServerMeter.new(s, 0, 2);

{SinOsc.ar(300+(200*Latch.ar(SinOsc.ar(13.3), Impulse.ar(10))))*0.2}.stop



