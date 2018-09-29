(

var path = PathName.new("C:/Users/edoca/Documents/Università/Computer Music/Project/Progetto w Vago/AKWF/AKWF_ebass/AKWF_ebass_0005.wav");
a = Buffer.read(s, Platform.resourceDir +/+ "AKWF/AKWF_ebass/AKWF_ebass_0005.wav");
b = Buffer.read(s, Platform.resourceDir +/+ "AKWF/AKWF_ebass/AKWF_ebass_0005.wav");
c = Buffer.read(s, Platform.resourceDir +/+ "AKWF/AKWF_ebass/AKWF_ebass_0005.wav");
d = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "AKWF/AKWF_ebass/AKWF_ebass_0005.wav");
e = Buffer.read(s, Platform.resourceDir +/+ "sounds/looperman-l-0000014-0000103-bentleyrhythmace-bra-slip-back-beats.wav");

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
//TempoClock.default.tempo = 0.35953685899971 * 4; //durata della battuta (è uguale all'inverso della durata dell'envelope per 4!)

TempoClock.default.tempo = 1;

p = Ptpar([
    0, Pbind(
        \instrument, \oneLoop,
        \bufnum, e,
        \amp, 0.4,
        \start, 1, //sample di inizio della lettura del buffer
		\time, 8, //sustain time dell'envelope, è uguale al reciproco della durata di un quarto del tempo = 1/4 del 4/4!
        \dur, 8
    )/*,
	0.5, Pbind(
        \instrument, \oneLoop,
        \bufnum, b,
        \amp, 0.4,
        \start, 1, //sample di inizio della lettura del buffer
		\time, 0.35953685899971.reciprocal, //sustain time dell'envelope, è uguale al reciproco della durata di un quarto del tempo = 1/4 del 4/4!
        \dur, 4
    ),
	0.5, Pbind(
        \instrument, \oneLoop,
        \bufnum, c,
        \amp, 0.4,
        \start, 1, //sample di inizio della lettura del buffer
		\time, 0.35953685899971.reciprocal, //sustain time dell'envelope, è uguale al reciproco della durata di un quarto del tempo = 1/4 del 4/4!
        \dur, 4
    )*//*,
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
    inf)*/,
    0.5, Pbind( // CASSA
        \instrument, \bell,
        \accent, -0.6,
        \amp, 0.2,
        \decayScale, 0.1,
        \dur, 4
    )
], 1).play; //Ptpar genera una sequenza di routine distanziata dell'offset che precede la routine stessa (in questo caso si differenziano di 0.5 e 0.5!
)

p.stop;