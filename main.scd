s.boot;

~synapse = NetAddr.new("127.0.0.1", 12346);
~wekinator = NetAddr.new("127.0.0.1", 6448);

b = Buffer.readChannel(s, Platform.resourceDir +/+ "sounds/140loop.wav", channels: [1]);


SynthDef(\oneLoop, { |out, bufnum, start, time, amp|
    var    sig = PlayBuf.ar(1, bufnum, startPos: start, loop: 0),
        env = EnvGen.kr(Env.linen(0.01, time, 0.05, level: amp), doneAction: Done.freeSelf);
    Out.ar(out, (sig * env) ! 2)
}).add;


SynthDef(\singrain, { |freq = 440, amp = 0.2, sustain = 1|
    var sig;
    sig = SinOsc.ar(freq, 0, amp) * EnvGen.kr(Env.perc(0.01, sustain), doneAction: Done.freeSelf);
    Out.ar(0, sig ! 2);    // sig ! 2 is the same as [sig, sig]
}).add;

TempoClock.default.tempo = 2.3;

p = Ptpar([
    0, Pbind(
        \instrument, \oneLoop,
        \bufnum, b,
        \amp, 0.4,
        \start, 0, //sample di inizio della lettura del buffer
		\time, 14, //sustain time dell'envelope, è uguale al reciproco della durata di un quarto del tempo = 1/4 del 4/4!
        \dur, 14
    )
]); //Ptpar genera una sequenza di routine distanziata dell'offset che precede la routine stessa (in questo caso si differenziano di 0.5 e 0.5!


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
		//msg.postln;
		~wekinator.sendMsg('/righthand_pos_screen', msg[1], msg[2], msg[3]);
	},
	'/righthand_pos_screen',
	nil,
	12345
);

//OSCdef per ricevere pacchetti da wekinator
OSCdef.new(
	\wekiReceiver,
	{
		arg msg;
		msg.postln;
		if(p.isPlaying == false && msg[1] == 1)
		{p.play(quant:4);};
		if(p.isPlaying == true && msg[1] == 2)
		{
			p.stop;
			p.reset;
		};
	},
	'/wek/event',
	nil,
	12000
);

)


