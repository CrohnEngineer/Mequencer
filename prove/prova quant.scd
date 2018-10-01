(
SynthDef(\singrain, { |freq = 440, amp = 0.2, sustain = 1|
    var sig;
    sig = SinOsc.ar(freq, 0, amp) * EnvGen.kr(Env.perc(0.01, sustain), doneAction: Done.freeSelf);
    Out.ar(0, sig ! 2);    // sig ! 2 is the same as [sig, sig]
}).add;
)

(
f = {
    Task({
        loop {
            [60, 62, 64, 65, 67, 69, 71, 72].do({ |midi|
                Synth(\singrain, [freq: midi.midicps, amp: 0.2, sustain: 0.1]);
                1.wait;
            });
        }
    });
};
)

TempoClock.default.tempo = 2;

t = f.value.play(quant: 4);        // start on next 4-beat boundary

u = f.value.play(quant: [4, 0.25]);    // next 4-beat boundary + a half-beat

t.stop; u.stop;