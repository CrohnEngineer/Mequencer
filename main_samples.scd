s.boot;

d = Dictionary.new;
~processing = NetAddr("127.0.0.1", 12001);

(
var samplePath = thisProcess.nowExecutingPath.dirname +/+ "sounds/808/"; //MAC
//var samplePath = Platform.resourceDir +/+ "sounds/808/"; //Windows

d.add(\808 ->
	PathName(samplePath).entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
});)
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
Pdef(
	\kickpattern,
	Pbind(
		\instrument, \kick,
		\dur, Pseq([1], inf),
		\decayTime, Pseq([0.4, 0.4, 2, 0.4, 0.4], inf),
		\rate, Pseq([1, 1, 1, 1, 1, 1, 1, 1, 1, 1], inf),
		\amp, 1,
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
	);
);

Pdef(
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

s.plotTree

(
// //OSCdef per ricevere pacchetti da wekinator
// var premsg = 0;
// OSCdef.new(
// 	\wekiReceiver,
// 	{
// 		arg msg;
// 		msg[1].postln;
// 		if(Pdef(\kickpattern).isPlaying == false && msg[1] == 1 && msg[1] != premsg) //quando arriva il secondo pacchetto, Pdef.isPlaying == false diventa falsa, e l'if va subito nella condizione dell'else fermando la routine
// 		{Pdef(\kickpattern).play(quant:1);}
// 		{};
// 		/*if(Pdef(\kickpattern).isPlaying == true && msg[1] == 1)
// 		{
// 		Pdef(\kickpattern).stop;
// 		}{};*/
// 		if(Pdef(\hatclosedpattern).isPlaying == false && msg[1] == 2) //quando arriva il secondo pacchetto, Pdef.isPlaying == false diventa falsa, e l'if va subito nella condizione dell'else fermando la routine
// 		{Pdef(\hatclosedpattern).play(quant:1);}
// 		{};
// 		if(Pdef(\hatclosedpattern).isPlaying == true && msg[1] == 2)
// 		{
// 			Pdef(\hatclosedpattern).stop;
// 		}{};
// 		if(Pdef(\clappattern).isPlaying == false && msg[1] == 3) //quando arriva il secondo pacchetto, Pdef.isPlaying == false diventa falsa, e l'if va subito nella condizione dell'else fermando la routine
// 		{Pdef(\clappattern).play(quant:1);}
// 		{};
// 		if(Pdef(\clappattern).isPlaying == true && msg[1] == 3)
// 		{
// 			Pdef(\clappattern).stop;
// 		}{};
// 		if(Pdef(\snarepattern).isPlaying == false && msg[1] == 4) //quando arriva il secondo pacchetto, Pdef.isPlaying == false diventa falsa, e l'if va subito nella condizione dell'else fermando la routine
// 		{Pdef(\snarepattern).play(quant:1);}
// 		{};
// 		/*if(Pdef(\snarepattern).isPlaying == true && msg[1] == 4)
// 		{
// 		Pdef(\snarepattern).stop;
// 		}{};*/
// 		premsg = msg[1];
// 	},
// 	'/wek/event',
// 	nil,
// 	12000
// );

OSCdef.new(
	\trackRHforward,
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

OSCdef.new(
	\trackLHforward,
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

/*OSCdef.new(
	\trackRHup,
	{
		arg msg;
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
);*/


/*OSCdef.new(
	\trackLHup,
	{
		arg msg;
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
);*/

)

b = NetAddr.new("127.0.0.1", 12345);    // create the NetAddr
b.sendMsg("/righthand", \forward);
b.sendMsg("/righthand", \up);
b.sendMsg("/lefthand", \forward);
b.sendMsg("/lefthand", \up);


s.plotTree
ServerMeter.new(s, 0, 2);

{SinOsc.ar(300+(200*Latch.ar(SinOsc.ar(13.3), Impulse.ar(10))))*0.2}.stop



