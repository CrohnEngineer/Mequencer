(
~atmo = Buffer.readChannel(s, "/Applications/SuperCollider/sounds/ATMOSCHIME.wav", channels:[1]);
~chain = Buffer.readChannel(s, "/Applications/SuperCollider/sounds/CHAINED.wav", channels:[1]);

SynthDef.new(\grain, {
	arg buf=0, trnsp=0, spos=0, atk=0.01, sus=0.03, rel=0.01, pan=0, amp=1, out=0;
	var sig, env;
	sig = PlayBuf.ar(1, buf, BufRateScale.ir(buf)*trnsp.midiratio, startPos:spos, doneAction:2);
	sig = Pan2.ar(sig,pan,amp);
	env = EnvGen.kr(Env.new([0,1,1,0],[atk,sus,rel],[1,0,-1]), doneAction:2);
	sig = sig*env;
	Out.ar(out,sig);
}).add;

SynthDef.new(\echo, {
	arg in, t_fxtrig=0, out=0;
	var sig, fx, mix;
	sig = In.ar(in,2);
	fx = In.ar(in,2);
	3.do{fx = CombL.ar(fx, 0.25, LFNoise1.kr(0.05).range(0.04, 0.25), 4, 0.65)};
	mix = EnvGen.kr(Env.new([-0.9, 0.75, -0.9], [0.1, 5], \lin), t_fxtrig);
	sig = XFade2.ar(sig, fx, mix);
	Out.ar(out,sig);
}).add;

~fxbus = Bus.audio(s,2);
~grainGrp = Group.new;
~fxGrp = Group.after(~grainGrp);
)


(
~atmoPat = Pbind(
	\instrument, \grain,
	\dur, Pdefn(\durAtmo, 0.1),
	\buf, ~atmo.bufnum,
	\sus, Pexprand(0.01, 0.1),
	\trnsp, Pdefn(\trnspAtmo, Pwhite(0, 0)),
	\spos, Pdefn(\sposAtmo, 0),
	\pan, Pwhite(-1.0, 1.0),
	\amp, Pdefn(\ampAtmo, 0.1),
	\group, ~grainGrp,
	\out, ~fxbus
);

~chainPat = Pbind(
	\instrument, \grain,
	\dur, Pdefn(\durChain, 0.1),
	\buf, ~chain.bufnum,
	\sus, Pexprand(0.01, 0.1),
	\trnsp, Pdefn(\trnspChain, Pwhite(0, 0)),
	\spos, Pdefn(\sposChain, 0),
	\pan, Pwhite(-1.0, 1.0),
	\amp, Pdefn(\ampChain, 0.1),
	\group, ~grainGrp,
	\out, ~fxbus
);

Synth.new(\echo, [\in, ~fxbus, \out, 0], ~fxGrp);
)

(
~trackHands = Task.new({
	{
		~synapse.sendMsg("/righthand_trackjointpos", 3);
		~synapse.sendMsg("/lefthand_trackjointpos", 3);
		2.wait;
	}.loop;
}).play;

OSCdef.new(
	\trackLHpos,
	{
		arg msg;
		Pdefn(\sposAtmo, msg[1].linlin(0,640,0,~atmo.numFrames-1));
		Pdefn(\durAtmo, msg[2].linexp(0,480,0.002,1.5));
		Pdefn(\ampAtmo, Pexprand(msg[2].linlin(0,480,-16,-36).dbamp, 0.25));
		Pdefn(\trnspAtmo, Pwhite(msg[3].linlin(800,2500,0,-36), msg[3].linlin(800,2500,0,36)));
	},
	'/lefthand_pos_screen',
	nil,
	12345
);

OSCdef.new(
	\trackRHpos,
	{
		arg msg;
		msg.postln;
		Pdefn(\sposChain, msg[1].linlin(0,640,0,~chain.numFrames-1));
		Pdefn(\durChain, msg[2].linexp(0,480,0.002,1.5));
		Pdefn(\ampChain, Pexprand(msg[2].linlin(0,480,-16,-36).dbamp, 0.25));
		Pdefn(\trnspChain, Pwhite(msg[3].linlin(800,2500,0,-36), msg[3].linlin(800,2500,0,36)));
	},
	'/righthand_pos_screen',
	nil,
	12345
);

OSCdef.new(
	\trackLHhit,
	{
		arg msg;
		msg.postln;
		if(
			msg[1] == \forward,
			{~fxGrp.set(\t_fxtrig, 1)}
		);
	},
	'/lefthand',
	nil,
	12345
);

OSCdef.new(
	\trackRHhit,
	{
		arg msg;
		if(
			msg[1] == \forward,
			{~fxGrp.set(\t_fxtrig, 1)}
		);
	},
	'/righthand',
	nil,
	12345
);
)

(
~atmoStream.stop;
~chainStream.stop•;
)
