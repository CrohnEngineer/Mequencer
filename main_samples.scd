s.boot;

(

~samplePath = thisProcess.nowExecutingPath.dirname +/+ "sounds/drumset/"; //MAC
//~samplePath = Platform.resourceDir +/+ "sounds/808/"; //Windows

TempoClock.tempo=90/60;
d = Dictionary.new;

~synapseSend = NetAddr.new("127.0.0.1", 12345);    // create the NetAddr
~synapseReceive = NetAddr.new("127.0.0.1", 12346);    // create the NetAddr
~wekinator = NetAddr.new("127.0.0.1", 6448); //Wekinator port for sending the righthand position
~wekinator1 = NetAddr.new("127.0.0.1", 6449); //Wekinator port for sending the lefthand position
~processing = NetAddr("127.0.0.1", 12001);

~b1 = Bus.audio(s, 2);

~modes = [1,0,0,0];
~pSample = [7, 3, 15, 13];
~pSeq = [0, 6, 10, 3];

d.add(\808 ->
	PathName(~samplePath).entries.collect({
		arg sf;
		Buffer.read(s, sf.fullPath);
}););

//CLOCK PATTERN
r = Routine({
	loop {
		NetAddr("127.0.0.1", 12001).sendMsg("/tempo", \tempo);
		0.25.yield;
	}
}).play(quant:4);

//PATTERNS
/*p = [
	[1],
	[0.5],
	[0.25],
	[1, 1, 1.25, 0.25, 0.50],
	[1, Rest(0.5), 1.5, 1],
	[1, Rest(1.5), 1.5],
	[Rest(0.5), 0.5],
	[Rest(0.5), 0.25, 0.25],
	[0.5, 0.5, Rest(0.25), 0.75],
	[0.75, 0.75, 0.75, 1.75],
	[Rest(1), 1],
	[Rest(2), 2],
	[0.5, Rest(1.5), 0.5, 0.5, Rest(1)],
	[0.25, 0.25, 0.25, 1.25, 0.25, Rest(0.25), 0.25, 0.50, 0.50, 0.25],
	[0.5, 0.5, Rest(0.75), 0.25, 0.5, 0.5, Rest(1)],
	[Rest(0.50), 0.75, 0.25, Rest(0.75), 0.25, 0.5, 1]
];*/

p = [
	[1],
	[0.5],
	[0.25],
	[1, 1, 1.25, 0.25, 0.50],
	[1, Rest(0.5), 1.5, 1],
	[1, Rest(1.5), 1.5],
	[Rest(0.5), 0.5], //hatclosed
	[Rest(0.5), 0.25, 0.25],
	[0.5, 0.5, Rest(0.25), 0.75],
	[0.75, 0.75, 0.75, 1.75],
	[Rest(1), 1], //clap/snare
	[Rest(2), 2],
	[0.5, Rest(1.5), 0.5, 0.5, Rest(1)],
	[0.75, 1.25, 0.75, 1.25], //kick
	[Rest(1.75), 0.5, 0.5, Rest(1.25)], //rimshot
	[Rest(0.50), 0.75, 0.25, Rest(0.75), 0.25, 0.5, 1]
];

i = [
	\sample1,
	\sample2,
	\sample3,
	\sample4,
	\sample5,
	\sample6,
	\sample7,
	\sample8,
	\sample9,
	\sample10,
	\sample11,
	\sample12,
	\sample13,
	\sample14,
	\sample15,
	\sample16
];


//Clips synth definitions

//SAMPLE1

SynthDef.new(\sample1, {
	arg rate = 1, amp=0.5, decayTime = 0, outBus = 0;
	var sig, env;
	sig = PlayBuf.ar(2,0, BufRateScale.ir(0)*rate, doneAction: 2);
	env = EnvGen.ar(Env.adsr(0,decayTime,0,1));
	sig = sig * env;
	sig = sig * amp;
	Out.ar(outBus, Pan2.ar(sig, 0, 1));
}).add;


//SAMPLE2

SynthDef.new(\sample2, {
	arg rate = 1, amp=0.5, decayTime = 0, outBus = 0;
	var sig;
	sig = PlayBuf.ar(2,1, BufRateScale.ir(1)*rate, doneAction: 2);
	sig = sig * amp;
	Out.ar(outBus, Pan2.ar(sig, 0, 1));
}).add;


//SAMPLE3

SynthDef.new(\sample3, {
	arg rate = 1, amp=0.5, decayTime = 0, outBus = 0;
	var sig, env;
	sig = PlayBuf.ar(2,2, BufRateScale.ir(2)*rate, doneAction: 2);
	env = EnvGen.ar(Env.adsr(0,decayTime,0,1));
	sig = sig * env;
	sig = sig * amp;
	Out.ar(outBus, Pan2.ar(sig, 0, 1));
}).add;

//SAMPLE4

SynthDef.new(\sample4, {
	arg rate = 1, amp=0.5, decayTime = 0, outBus = 0;
	var sig, env;
	sig = PlayBuf.ar(2,3, BufRateScale.ir(3)*rate, doneAction: 2);
	env = EnvGen.ar(Env.adsr(0,decayTime,0,1));
	sig = sig * env;
	sig = sig * amp;
	Out.ar(outBus, Pan2.ar(sig, 0, 1));
}).add;

//SAMPLE5

SynthDef.new(\sample5, {
	arg rate = 1, amp=0.5, decayTime = 0, outBus = 0;
	var sig, env;
	sig = PlayBuf.ar(2,4, BufRateScale.ir(4)*rate, doneAction: 2);
	env = EnvGen.ar(Env.adsr(0,decayTime,0,1));
	sig = sig * env;
	sig = sig * amp;
	Out.ar(outBus, Pan2.ar(sig, 0, 1));
}).add;

//SAMPLE6

SynthDef.new(\sample6, {
	arg rate = 1, amp=0.5, decayTime = 0, outBus = 0;
	var sig, env;
	sig = PlayBuf.ar(2,5, BufRateScale.ir(5)*rate, doneAction: 2);
	env = EnvGen.ar(Env.adsr(0,decayTime,0,1));
	sig = sig * env;
	sig = sig * amp;
	Out.ar(outBus, Pan2.ar(sig, 0, 1));
}).add;

//SAMPLE7

SynthDef.new(\sample7, {
	arg rate = 1, amp=0.5, decayTime = 0, outBus = 0;
	var sig, env;
	sig = PlayBuf.ar(2,6, BufRateScale.ir(6)*rate, doneAction: 2);
	env = EnvGen.ar(Env.adsr(0,decayTime,0,1));
	sig = sig * env;
	sig = sig * amp;
	Out.ar(outBus, Pan2.ar(sig, 0, 1));
}).add;

//SAMPLE8

SynthDef.new(\sample8, {
	arg rate = 1, amp=0.5, decayTime = 0, outBus = 0;
	var sig, env;
	sig = PlayBuf.ar(2,7, BufRateScale.ir(7)*rate, doneAction: 2);
	env = EnvGen.ar(Env.adsr(0,decayTime,0,1));
	sig = sig * env;
	sig = sig * amp;
	Out.ar(outBus, Pan2.ar(sig, 0, 1));
}).add;

//SAMPLE9

SynthDef.new(\sample9, {
	arg rate = 1, amp=0.5, decayTime = 0, outBus = 0;
	var sig, env;
	sig = PlayBuf.ar(2,8, BufRateScale.ir(8)*rate, doneAction: 2);
	env = EnvGen.ar(Env.adsr(0,decayTime,0,1));
	sig = sig * env;
	sig = sig * amp;
	Out.ar(outBus, Pan2.ar(sig, 0, 1));
}).add;

//SAMPLE10

SynthDef.new(\sample10, {
	arg rate = 1, amp=0.5, decayTime = 0, outBus = 0;
	var sig, env;
	sig = PlayBuf.ar(2,9, BufRateScale.ir(9)*rate, doneAction: 2);
	env = EnvGen.ar(Env.adsr(0,decayTime,0,1));
	sig = sig * env;
	sig = sig * amp;
	Out.ar(outBus, Pan2.ar(sig, 0, 1));
}).add;

//SAMPLE11

SynthDef.new(\sample11, {
	arg rate = 1, amp=0.5, decayTime = 0, outBus = 0;
	var sig, env;
	sig = PlayBuf.ar(2,10, BufRateScale.ir(10)*rate, doneAction: 2);
	env = EnvGen.ar(Env.adsr(0,decayTime,0,1));
	sig = sig * env;
	sig = sig * amp;
	Out.ar(outBus, Pan2.ar(sig, 0, 1));
}).add;

//SAMPLE12

SynthDef.new(\sample12, {
	arg rate = 1, amp=0.5, decayTime = 0, outBus = 0;
	var sig, env;
	sig = PlayBuf.ar(2,11, BufRateScale.ir(11)*rate, doneAction: 2);
	env = EnvGen.ar(Env.adsr(0,decayTime,0,1));
	sig = sig * env;
	sig = sig * amp;
	Out.ar(outBus, Pan2.ar(sig, 0, 1));
}).add;

//SAMPLE13

SynthDef.new(\sample13, {
	arg rate = 1, amp=0.5, decayTime = 0, outBus = 0;
	var sig, env;
	sig = PlayBuf.ar(2,12, BufRateScale.ir(12)*rate, doneAction: 2);
	env = EnvGen.ar(Env.adsr(0,decayTime,0,1));
	sig = sig * env;
	sig = sig * amp;
	Out.ar(outBus, Pan2.ar(sig, 0, 1));
}).add;

//SAMPLE14

SynthDef.new(\sample14, {
	arg rate = 1, amp=0.5, decayTime = 0, outBus = 0;
	var sig, env;
	sig = PlayBuf.ar(2,13, BufRateScale.ir(13)*rate, doneAction: 2);
	env = EnvGen.ar(Env.adsr(0,decayTime,0,1));
	sig = sig * env;
	sig = sig * amp;
	Out.ar(outBus, Pan2.ar(sig, 0, 1));
}).add;

//SAMPLE15

SynthDef.new(\sample15, {
	arg rate = 1, amp=0.5, decayTime = 0, outBus = 0;
	var sig, env;
	sig = PlayBuf.ar(2,14, BufRateScale.ir(14)*rate, doneAction: 2);
	env = EnvGen.ar(Env.adsr(0,decayTime,0,1));
	sig = sig * env;
	sig = sig * amp;
	Out.ar(outBus, Pan2.ar(sig, 0, 1));
}).add;

//SAMPLE16

SynthDef.new(\sample16, {
	arg rate = 1, amp=0.5, decayTime = 0, outBus = 0;
	var sig, env;
	sig = PlayBuf.ar(2,15, BufRateScale.ir(15)*rate, doneAction: 2);
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


//Pattern definitions

Pdef(
	\pattern1,
	Pbind(
		\instrument, Pfunc({ |e| e.instrument}),
		\dur, Pdefn(\dur1),
		\decayTime, 1,
		\rate, 1,
		\amp, 0.3,
		\outBus, ~b1,
		\x, Pfunc ({ |evt|
			if(evt.isRest == false){
				~processing.sendMsg("/sample1", \play);
			}{
				~processing.sendMsg("/pause1");
			}
		})
	);
);

Pdef(
	\pattern2,
	Pbind(
		\instrument, Pfunc({ |e| e.instrument}),
		\dur, Pdefn(\dur2),
		\decayTime, 0.5,
		\rate, 1,
		\amp, 0.3,
		\outBus, ~b1,
		\x, Pfunc ({ |evt|
			if(evt.isRest == false){
				~processing.sendMsg("/sample2", \play);
			}{
				~processing.sendMsg("/pause2");
			}
		})
	);
);

Pdef(
	\pattern3,
	Pbind(
		\instrument, Pfunc({ |e| e.instrument}),
		\dur, Pdefn(\dur3),
		\decayTime, 0.5,
		\rate, 1,
		\amp, 0.3,
		\outBus, ~b1,
		\x, Pfunc ({ |evt|
			if(evt.isRest == false){
				~processing.sendMsg("/sample3", \play);
			}{
				~processing.sendMsg("/pause3");
			}
		})
	);
);


Pdef(
	\pattern4,
	Pbind(
		\instrument, Pfunc({ |e| e.instrument}),
		\dur, Pdefn(\dur4),
		\decayTime, 0.5,
		\rate, 1,
		\amp, 0.3,
		\outBus, ~b1,
		\x, Pfunc ({ |evt|
			if(evt.isRest == false){
				~processing.sendMsg("/sample4", \play);
			}{
				~processing.sendMsg("/pause4");
			}
		})
	)
);

)

(
//Filters instantiation and instrument default initialization for each pattern

x = Synth.new(\filter, [\inBus, ~b1]);
y = Synth.after(x,\reverb);

Pdef(\pattern1).set(\instrument,\sample8);
Pdef(\pattern2).set(\instrument,\sample4);
Pdef(\pattern3).set(\instrument,\sample16);
Pdef(\pattern4).set(\instrument,\sample14);

Pdefn(\dur1,Pseq(p[13], inf));
Pdefn(\dur2,Pseq(p[6], inf));
Pdefn(\dur3,Pseq(p[10], inf));
Pdefn(\dur4,Pseq(p[14], inf));




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
			case

			{~modes[0] == 1}
			{
				if(Pdef(\pattern1).isPlaying == false)
				{
					"PLAY".postln;
					msg.postln;
					Pdef(\pattern1).play(quant:4);
					Routine.new({
						~processing.sendMsg("/seq1", "play");
					}).play(quant:4);
				}{
					"STOP".postln;
					Pdef(\pattern1).stop;
					Routine.new({
						~processing.sendMsg("/seq1", "stop");
				}).play(quant:4);			};
			}
			{~modes[2] == 1}
			{
				if( ~pSample[0] < 15) {
					~pSample[0] = ~pSample[0] + 1;
					~pSample[0].postln;
					i[~pSample[0]].postln;
					~processing.sendMsg("/change_sample", 1, ~pSample[0]);
				}
				{
					~pSample[0] = 0;
					~pSample[0].postln;
					i[~pSample[0]].postln;
					~processing.sendMsg("/change_sample", 1, ~pSample[0]);
				};
			}
			{~modes[3] == 1}
			{
				if( ~pSeq[0] < 15) {
					~pSeq[0] = ~pSeq[0] + 1;
					~processing.sendMsg("/change_sequence", 1, ~pSeq[0]);
				}
				{
					~pSeq[0] = 0;
					~processing.sendMsg("/change_sequence", 1, ~pSeq[0]);
				};
			}
		}{
			//do nothing
		};
		if(msg[1] == \up)
		{
			case

			{~modes[0] == 1}
			{
				if(Pdef(\pattern2).isPlaying == false)
				{
					"PLAY".postln;
					msg.postln;
					Pdef(\pattern2).play(quant:4);
					Routine.new({
						~processing.sendMsg("/seq2", "play");
					}).play(quant:4);
				}{
					"STOP".postln;
					Pdef(\pattern2).stop;
					Routine.new({
						~processing.sendMsg("/seq2", "stop");
					}).play(quant:4);
				};
			}
			{~modes[2] == 1}
			{
				if( ~pSample[1] < 15) {
					~pSample[1] = ~pSample[1] + 1;
					~pSample[1].postln;
					i[~pSample[1]].postln;
					~processing.sendMsg("/change_sample", 2, ~pSample[1]);
				}
				{
					~pSample[1] = 0;
					~pSample[1].postln;
					i[~pSample[1]].postln;
					~processing.sendMsg("/change_sample", 2, ~pSample[1]);
				};
			}
			{~modes[3] == 1}
			{
				if( ~pSeq[1] < 15) {
					~pSeq[1] = ~pSeq[1] + 1;
					~processing.sendMsg("/change_sequence", 2, ~pSeq[1]);
				}
				{
					~pSeq[1] = 0;
					~processing.sendMsg("/change_sequence", 2, ~pSeq[1]);
				};
			}
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
			case

			{~modes[0] == 1}
			{
				if(Pdef(\pattern3).isPlaying == false)
				{
					"PLAY".postln;
					msg.postln;
					Pdef(\pattern3).play(quant:4);
					Routine.new({
						~processing.sendMsg("/seq3", "play");
					}).play(quant:4);
				}{
					"STOP".postln;
					Pdef(\pattern3).stop;
					Routine.new({
						~processing.sendMsg("/seq3", "stop");
					}).play(quant:4);
				};
			}
			{~modes[2] == 1}
			{
				if( ~pSample[2] < 15) {
					~pSample[2] = ~pSample[2] + 1;
					~pSample[2].postln;
					i[~pSample[2]].postln;
					~processing.sendMsg("/change_sample", 3, ~pSample[2]);
				}
				{
					~pSample[2] = 0;
					~pSample[2].postln;
					i[~pSample[2]].postln;
					~processing.sendMsg("/change_sample", 3, ~pSample[2]);
				};
			}
			{~modes[3] == 1}
			{
				if( ~pSeq[2] < 15) {
					~pSeq[2] = ~pSeq[2] + 1;
					~processing.sendMsg("/change_sequence", 3, ~pSeq[2]);
				}
				{
					~pSeq[2] = 0;
					~processing.sendMsg("/change_sequence", 3, ~pSeq[2]);
				};
			}
		}{
			//do nothing
		};
		if(msg[1] == \up)
		{
			case

			{~modes[0] == 1}
			{
				if(Pdef(\pattern4).isPlaying == false)
				{
					"PLAY".postln;
					msg.postln;
					Pdef(\pattern4).play(quant:4);
					Routine.new({
						~processing.sendMsg("/seq4", "play");
					}).play(quant:4);
				}{
					"STOP".postln;
					Pdef(\pattern4).stop;
					Routine.new({
						~processing.sendMsg("/seq4", "stop");
					}).play(quant:4);
				};
			}
			{~modes[2] == 1}
			{
				if( ~pSample[3] < 15) {
					~pSample[3] = ~pSample[3] + 1;
					~pSample[3].postln;
					i[~pSample[3]].postln;
					~processing.sendMsg("/change_sample", 4, ~pSample[3]);
				}
				{
					~pSample[3] = 0;
					~pSample[3].postln;
					i[~pSample[3]].postln;
					~processing.sendMsg("/change_sample", 4, ~pSample[3]);
				};
			}
			{~modes[3] == 1}
			{
				if( ~pSeq[3] < 15) {
					~pSeq[3] = ~pSeq[3] + 1;
					~processing.sendMsg("/change_sequence", 4, ~pSeq[3]);
				}
				{
					~pSeq[3] = 0;
					~processing.sendMsg("/change_sequence", 4, ~pSeq[3]);
				};
			}
		}{
			//do nothing
		};
	},
	'/lefthand',
	nil,
	12345
);


//OSCdef for forwarding the righthand position to Wekinator
OSCdef.new(
\scForwardRHpos,
{
arg msg;
		~wekinator.sendMsg('/wek/righthand_pos_body', msg[1], msg[2], msg[3]);
		//msg.postln;
},
	'/righthand_pos_body',
nil,
12345
);

//OSCdef for forwarding the lefthand position to Wekinator
OSCdef.new(
\scForwardLHpos,
{
arg msg;
		~wekinator1.sendMsg('/wek/lefthand_pos_body', msg[1], msg[2]);
		//msg.postln;
},
'/lefthand_pos_body',
nil,
12345
);

//OSC function for setting the low-pass filter cutoff frequence values received from Wekinator
OSCdef.new(
	\wekiReceiverRight,
	{
		arg msg;
		//msg.postln;
		if(~modes[1] == 1){
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
		if(~modes[1] == 1){
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

//OSC function for entering/exiting the launch mode through the touchOSC app
OSCdef.new(
	\enterLaunchState,
	{
		arg msg;
		msg.postln;
		msg[1].postln;

		~modes[0] = msg[1].asInteger;
		~modes.postln;
	},
	'/mode/1/1',
	nil,
	12000
);

//OSC function for entering/exiting the effect mode through the touchOSC app
OSCdef.new(
	\enterEffectState,
	{
		arg msg;
		msg.postln;
		msg[1].postln;

		~modes[1] = msg[1].asInteger;
		~modes.postln;
	},
	'/mode/1/2',
	nil,
	12000
);

//OSC function for entering/exiting the sample selecetion mode through the touchOSC app
OSCdef.new(
	\enterSampleSelectionState,
	{
		arg msg;
		msg.postln;
		msg[1].postln;

		~modes[2] = msg[1].asInteger;
		~modes.postln;
	},
	'/mode/1/3',
	nil,
	12000
);

//OSC function for entering/exiting the sequence selection mode through the touchOSC app
OSCdef.new(
	\enterSequenceSelectionState,
	{
		arg msg;
		msg.postln;
		msg[1].postln;

		~modes[3] = msg[1].asInteger;
		~modes.postln;
	},
	'/mode/1/4',
	nil,
	12000
);

//OSC function receiving the selected pattern from processing
OSCdef.new(
	\processingPattern,
	{
		arg msg;
		msg.postln;
		case

		{msg[1] == 1}
		{
			Pdefn(\dur1,Pseq(p[msg[2]], inf));
			if(Pdef(\pattern1).isPlaying == true){
				Pdef(\pattern1).stop;
				Pdef(\pattern1).play(quant:4);
			}{};
			~pSeq[0] = msg[2].asInteger;
		}

		{msg[1] == 2}
		{
			Pdefn(\dur2,Pseq(p[msg[2]], inf));
			if(Pdef(\pattern2).isPlaying == true){
				Pdef(\pattern2).stop;
				Pdef(\pattern2).play(quant:4);
			}{};
			~pSeq[1] = msg[2].asInteger;
		}

		{msg[1] == 3}
		{
			Pdefn(\dur3,Pseq(p[msg[2]], inf));
			if(Pdef(\pattern3).isPlaying == true){
				Pdef(\pattern3).stop;
				Pdef(\pattern3).play(quant:4);
			}{};
			~pSeq[2] = msg[2].asInteger;
		}

		{msg[1] == 4}
		{
			Pdefn(\dur4,Pseq(p[msg[2]], inf));
			if(Pdef(\pattern4).isPlaying == true){
				Pdef(\pattern4).stop;
				Pdef(\pattern4).play(quant:4);
			}{};
			~pSeq[3] = msg[2].asInteger;
		};
	},
	'/pattern',
	nil,
	12002
);

//OSC function receiving the selected sample
OSCdef.new(
	\processingSample,
	{
		arg msg;
		msg.postln;
		case

		{msg[1] == 1}
		{
			Pdef(\pattern1).set(\instrument, i[msg[2]]);
			~pSample[0] = msg[2].asInteger;
		}

		{msg[1] == 2}
		{
			Pdef(\pattern2).set(\instrument, i[msg[2]]);
			~pSample[1] = msg[2].asInteger;
		}

		{msg[1] == 3}
		{
			Pdef(\pattern3).set(\instrument, i[msg[2]]);
			~pSample[2] = msg[2].asInteger;
		}

		{msg[1] == 4}
		{
			Pdef(\pattern4).set(\instrument, i[msg[2]]);
			~pSample[3] = msg[2].asInteger;
		};
	},
	'/sample',
	nil,
	12002
);

// ~cSampState = 0;
//~modes[0]=1;

~synapseSend.sendMsg("/righthand", \forward);
~synapseSend.sendMsg("/righthand", \up);
~synapseSend.sendMsg("/lefthand", \forward);
~synapseSend.sendMsg("/lefthand", \up);

)
