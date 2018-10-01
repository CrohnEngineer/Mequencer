s.boot;

~synapse = NetAddr.new("127.0.0.1", 12346);
~wekinator = NetAddr.new("127.0.0.1", 6448);

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
	},
	'/wek/event',
	nil,
	12000
);


)


