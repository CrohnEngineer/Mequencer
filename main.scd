s.boot;

~synapse = NetAddr.new("127.0.0.1", 12346);
~wekinator = NetAddr.new("127.0.0.1", 6448);

b = Buffer.readChannel(s, Platform.resourceDir +/+ "sounds/140loop.wav", channels: [1]);
c = Buffer.readChannel(s, Platform.resourceDir +/+ "sounds/140bass.wav", channels: [1]);



SynthDef(\beatLoop, { |out, bufnum, start, time, amp|
    var sig = PlayBuf.ar(1, bufnum, startPos: start, loop: 0),
        env = EnvGen.kr(Env.linen(0.01, time, 0.05, level: amp), doneAction: Done.freeSelf);
    Out.ar(out, (sig * env) ! 2)
}).add;

SynthDef(\bassLoop, { |out, bufnum, start, time, amp|
    var sig = PlayBuf.ar(1, bufnum, startPos: start, loop: 0),
        env = EnvGen.kr(Env.linen(0.01, time, 0.05, level: amp), doneAction: Done.freeSelf);
    Out.ar(out, (sig * env) ! 2)
}).add;

TempoClock.default.tempo = 2.3333333333333333333;

(
p = Pbind(
        \instrument, \beatLoop,
        \bufnum, b,
        \amp, 1,
        \start, 0, //sample di inizio della lettura del buffer
		\time, 32, //sustain time dell'envelope, è uguale al reciproco della durata di un quarto del tempo = 1/4 del 4/4!
        \dur, 32
).play(quant: 4);
)

(
q = Pbind(
        \instrument, \bassLoop,
        \bufnum, c,
        \amp, 0.5,
        \start, 0, //sample di inizio della lettura del buffer
		\time, 32, //sustain time dell'envelope, è uguale al reciproco della durata di un quarto del tempo = 1/4 del 4/4!
        \dur, 32
).play(quant:4);
)

p.stop; p.reset;
q.stop; q.reset;

//task per chiedere pacchetti a synapse
(
~trackHands = Task.new({
	{
		~synapse.sendMsg("/righthand_trackjointpos", 3);
		2.wait;
	}.loop;
}).play;

//OSCdef per ricevere pacchetti da synapse e mandarli a wekinator
OSCdef.new(
	\synapseReceiver,
	{
		arg msg;
		~wekinator.sendMsg('/wek/inputs', msg[1], msg[2], msg[3]);
	},
	'/wek/inputs',
	nil,
	12345
);

//OSCdef per ricevere pacchetti da wekinator
OSCdef.new(
	\wekiReceiverRight,
	{
		arg msg;
		msg.postln;
		if(p.isPlaying == false && msg[1] == 2)
		{p.play(quant:1);};
		if(p.isPlaying == true && msg[1] == 2)
		{
			p.stop;
		};
	},
	'/wek/outputs',
	nil,
	12000
);

)

