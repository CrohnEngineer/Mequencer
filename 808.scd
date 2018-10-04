s.boot;

d = Dictionary.new;

var samplePath = thisProcess.nowExecutingPath.dirname +/+ "sounds/808/";

d.add(\808 ->
	PathName(samplePath).entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
});
)

TempoClock.tempo=2.1;

//KICK
(
SynthDef.new(\kick, {
	arg rate = 1, amp=1, decayTime = 0;
	var sig, env;
	sig = PlayBuf.ar(1,0, BufRateScale.ir(0)*rate, doneAction: 2);
	env = EnvGen.ar(Env.adsr(0,decayTime,0,1));
	sig = sig * env;
	sig = sig * amp;
	Out.ar(0, Pan2.ar(sig, 0, 1));
}).add;


//CLOSED HAT

SynthDef.new(\hatclosed, {
	arg rate = 1, amp=1, pan=0;
	var sig;
	sig = PlayBuf.ar(1,2, BufRateScale.ir(2)*rate, doneAction: 2);
	sig = sig * amp;
	Out.ar(0, Pan2.ar(sig, pan, 1));
}).add;


//CLAP

SynthDef.new(\clap, {
	arg rate = 1, amp=1, decayTime = 0;
	var sig, env;
	sig = PlayBuf.ar(1,4, BufRateScale.ir(4)*rate, doneAction: 2);
	env = EnvGen.ar(Env.adsr(0,decayTime,0,1));
	sig = sig * env;
	sig = sig * amp;
	Out.ar(0, Pan2.ar(sig, 0, 1));
}).add;


//SNARE

SynthDef.new(\snare, {
	arg rate = 1, amp=1, decayTime=0;
	var sig, env;
	sig = PlayBuf.ar(1,15, BufRateScale.ir(15)*rate, doneAction: 2);
	env = EnvGen.ar(Env.adsr(0,decayTime,0,1));
	sig = sig * env;
	sig = sig * amp;
	Out.ar(0, Pan2.ar(sig, 0, 1));
}).add;
)



(
~kick = Pdef(
	\kickpattern,
	Pbind(
		\instrument, \kick,
		\dur, Pseq([3/4, 3/4, 1, 3/4, 3/4], inf),
		//\dur, 1,
		\decayTime, Pseq([0.4, 0.4, 2, 0.4, 0.4], inf),
		\rate, Pseq([1, 1, 1, 1, 1, 1, 1, 2, 1, 1], inf),
		\amp, 0.5,
	);
);


~hatclosed = Pdef(
	\hatclosedpattern,
	Pbind(
		\instrument, \hatclosed,
		\dur, Pseq([1/4], inf),
		\rate, Pwhite(0.9, 1, inf),
		\amp, Pseq([0.1, 0.2, 0.6, 0.6, 0.1, 0.2, 0.6, 0.6], inf),
		\pan, Pwhite(-0.5, 0.5, inf),
	);
);


~clap = Pdef(
	\clappattern,
	Pbind(
		\instrument, \clap,
		\dur, Pseq([1], inf),
		\decayTime, 0.4,
		\rate, 2,
		\amp,  Pseq([0, 0.5, 0, 0.5], inf),
	);
);

~snare = Pdef(
	\snarepattern,
	Pbind(
		\instrument, \snare,
		\dur, Pseq([1], inf),
		\decayTime, 1,
		\rate, 2,
		\amp,  Pseq([0, 0.5], inf),
	)
);
)



~kick.play(quant: 4);
~kick.stop;

~hatclosed.play(quant: 4);
~hatclosed.stop;

~clap.play(quant: 4);
~clap.stop;

~snare.play(quant: 4);
~snare.stop;