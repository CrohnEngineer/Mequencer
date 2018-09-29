(
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

// one loop segment
SynthDef(\oneLoop, { |out, bufnum, start, time, amp|
    var    sig = PlayBuf.ar(1, bufnum, startPos: start, loop: 0),
        env = EnvGen.kr(Env.linen(0.01, time, 0.05, level: amp), doneAction: Done.freeSelf);
    Out.ar(out, (sig * env) ! 2)
}).add;

SynthDef(\bell, { |out, accent = 0, amp = 0.1, decayScale = 1|
    var    exc = PinkNoise.ar(amp)
            * Decay2.kr(Impulse.kr(0), 0.01, 0.05),
        sig = Klank.ar(`[
            { ExpRand(400, 1600) } ! 4,
            1 ! 4,
            { ExpRand(0.1, 0.4) } ! 4
        ], exc, freqscale: accent + 1, decayscale: decayScale);
    DetectSilence.ar(sig, doneAction: Done.freeSelf);
    Out.ar(out, sig ! 2)
}).add;
)

(
TempoClock.default.tempo = 0.35953685899971 * 4; //durata della battuta (è uguale all'inverso della durata dell'envelope per 4!)

p = Ptpar([
    0, Pbind(
        \instrument, \oneLoop,
        \bufnum, b,
        \amp, 0.4,
        \start, 17841, //sample di inizio della lettura del buffer
		\time, 0.35953685899971.reciprocal, //sustain time dell'envelope, è uguale al reciproco della durata di un quarto del tempo = 1/4 del 4/4!
        \dur, 4
    ),
    0.5, Pn( //Pn embedda una serie di routine in un unico stream di eventi, di durata voluta: in questo caso è infinita
		Pfindur(4, //Pfindur limita la sequenza embeddata di eventi ad una durata finita (in questo caso la durata è di una battuta!) alla fine avremo una sequenza infinita di suoni di campane che durano 4/4!
            Pbind(
                \instrument, \bell,
				\accent, Pseq([2, Pn(0, inf)], 1), //CAMPANA
                \amp, Pseq([0.3, Pn(0.1, inf)], 1),
                \decayScale, Pseq([6, Pn(1, inf)], 1),
                \dur, Pwrand(#[0.25, 0.5, 0.75, 1], #[2, 3, 1, 1].normalizeSum, inf)
            )
        ),
    inf),
    0.5, Pbind( // CASSA
        \instrument, \bell,
        \accent, -0.6,
        \amp, 0.2,
        \decayScale, 0.1,
        \dur, 0.25
    )
], 1).play; //Ptpar genera una sequenza di routine distanziata dell'offset che precede la routine stessa (in questo caso si differenziano di 0.5 e 0.5!
)

p.stop;

//Pbind examples

a = Pbind(\x, Pseq([77,78,79]), \y, Pseq([1, 2, 3]));

x = a.asStream;

4.do { x.next(Event.new).postln };



a = Pbind(\x, 77, \y, Pseq([1, 2, 3]));

x = a.asStream;

x.next; // this returns nil.

//Ptpar examples

(
var a, b, c, t;
a = Pbind(\x, Pseq([1, 2, 3, 4]), \dur, 1);
b = Pbind(\x, Pseq([10, 20, 30, 40]), \dur, 0.4);
c = Ptpar([0.0, a, 1.3, b]);
t = c.asStream;
20.do({ t.next(Event.default).postln; });
)

// sound example
(
var a, b;
a = Pbind(\note, Pseq([7, 4, 0], 4), \dur, Pseq([1, 0.5, 1.5], inf));
b = Pbind(\note, Pseq([5, 10, 12], 4), \dur, 1);
Ptpar([ 0.0, a, 1.3, b ]).play;
)

//Pn examples

(
var a, b;
a = Pn(Pseq(#[1, 2, 3], 1), 4);    // repeat pattern four times
b = a.asStream;
16.do({ b.next.postln; });
)

//Pfindur examples
(
var a, b;
a = Pfindur(5, Pbind(\dur, Prand([1, 2, 0.5, 0.1], inf)));
x = a.asStream;
9.do({ x.next(Event.default).postln; });
)