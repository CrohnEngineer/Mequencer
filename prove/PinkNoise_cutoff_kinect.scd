s.boot;

~synapse = NetAddr.new("127.0.0.1", 12346);

~noise = {
	arg freq = 440, gate = 1, amp = 5;
	var sig;
	sig = PinkNoise.ar(1!2);
	sig = BPF.ar(sig, freq.lag(0.05), 0.3); //lag per smoothare il cutoff in caso di movimenti bruschi
	sig = sig * amp;
	sig = sig * EnvGen.kr(Env.adsr(5,0,1,2,1,1), gate, doneAction:2);
}.play;

(
~trackRH = Task.new({
	{
		~synapse.sendMsg("/righthand_trackjointpos", 3);
		2.wait;
	}.loop;
}).play;

OSCdef.new(
	\trackRH,
	{
		arg msg;
		~noise.set(
			\freq, msg[1].linexp(0,640,100,3000),
		); //linexp per mappare i pixel alla cutoff freq

	},
	'/righthand_pos_screen',
	nil,
	12345
);

OSCdef.new(
	\trackRHhit,
	{
		arg msg;
		msg.postln;
		if(
			msg[1] == \forward,
			{~noise.set(\gate,0);
				OSCdef.freeAll;
				~trackRH.stop;
			}
		);
	},
	'/righthand',
	nil,
	12345
);
)

(
~noise.set(\gate, 0);
OSCdef.freeAll;
~trackRH.stop;
)
