s.boot;

~synapse = NetAddr.new("127.0.0.1", 12346);

(
~trackHands = Task.new({
	{
		~synapse.sendMsg("/righthand_trackjointpos", 3);
		/*~synapse.sendMsg("/lefthand_trackjointpos", 3);*/
		2.wait;
	}.loop;
}).play;

OSCdef.new(
	\trackRHpos,
	{
		arg msg;
		msg.postln;
	},
	'/righthand_pos_screen',
	nil,
	12345
);
)