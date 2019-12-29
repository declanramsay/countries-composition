// Declan Doherty-Ramsay
// Final Assignment
// CMPO 281

// Sample from "THE VIRGIN SUICIDES"


(
s = Server.local;
b = Buffer.read(s, Platform.resourceDir +/+ "./vs-countries.aif");
)

(
SynthDef("arpeggio",{
	arg	 freq=440, decay=0.1, amp=1, len=1.075, width=0.5, lpf=1000, hpf=10;
	var	 sig, env;

	env = EnvGen.kr(
		Env.new(
			[0.001,1,decay,0.001],
			[0.025,len-0.025,0.02]*(1/5),
			\exponential),
		doneAction:2);
	sig = VarSaw.ar(freq,[0,0],width,amp);
	sig = HPF.ar(sig,hpf);
	sig = LPF.ar(sig,lpf);
	sig = sig*env;
	Out.ar(0, sig);
}).add;

SynthDef("leadline",{
	arg	 freq=440, decay=0.1, amp=0.8, len=1.075, width=0.5, lpf=10000, hpf=10;
	var	 sig, env;
	env = EnvGen.kr(
		Env.new(
			[0.001,1,decay,0.001],
			[0.025,len-0.025,0.02]*(1/5),
			\exponential),
		doneAction:2);
	sig = VarSaw.ar([freq*2, freq*2],[0,0],width,amp);

	sig = FreeVerb.ar(sig, 0.4, 0.2, 0.2, 0.8, 0);
	sig = sig*env;
	Out.ar(0, sig);
}).add;


SynthDef("bassline",{
	arg	 freq=440, decay=0.1, amp=1, len=1.075, width=0.5, lpf=10000, hpf=10;
	var	 sig, env;
	env = EnvGen.kr(
		Env.new(
			[0.001,1,decay,0.001],
			[0.025,len-0.025,0.02]*(1/5),
			\exponential),
		doneAction:2);
	sig = SinOsc.ar(freq/2,0,amp, 0);
	sig = HPF.ar(sig,hpf);
	sig = LPF.ar(sig,lpf);
	sig = sig*env;
	Out.ar(0, [sig, sig]);
}).add;

SynthDef("kick",{
	var subosc, subenv, suboutput, clickosc, clickenv, clickoutput;

   	subosc = SinOsc.ar(60);
    	subenv = Line.ar(1, 0, 1, doneAction: 2);

    	clickosc = LPF.ar(WhiteNoise.ar(1),1500);
    	clickenv = Line.ar(1, 0, 0.02);

    	suboutput = (subosc * subenv);
    	clickoutput = (clickosc * clickenv);

    Out.ar(0, Pan2.ar(suboutput + clickoutput, 0));
}).add;

SynthDef("snare", { | out = 0, freq = 60, length = 1, amp = 0.7 |
	var noise, filt, env;
	noise = PinkNoise.ar(0.75);
	env = EnvGen.kr(Env.perc(0.001, length, 1, -4), doneAction: 2);
	noise = env * noise;
	filt = RLPF.ar(noise, (env* [freq, freq+100]) +500, 0.95);
	filt = filt * amp;
	Out.ar(out, [filt, filt]);
	}).add;

SynthDef("chords",{
	arg	 freq=440, decay=0.1, amp=1, len=1.075, width=0.5;
	var	 sig, env;
	env = EnvGen.kr(
		Env.new(
			[0.001,1,decay,0.001],
			[0.025,len-0.025,0.02]*(1/5),
			\exponential),
		doneAction:2);
	sig = SinOsc.ar(freq,0, amp, 0);
	sig = sig*env;
	Out.ar(0, [sig, sig]);
}).add;

SynthDef("foundtext", {
|out = 0, gate = 0, bufnum = 0|
var sig, env;

	sig = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), loop: 0, doneAction: 2);
	sig = sig*0.1;

Out.ar(out, [sig, sig]);
}).add;

)
(
~arpeggio = Pbind(
	\instrument, \arpeggio,
	\dur, 0.25,
	\amp, Pseq([0.8, 0.5, 0.7, 0.4], 16),
	\midinote, Pseq([36, 39, 43, 39, 36, 39, 43, 39, 36, 39, 43, 39, 36, 39, 43, 39, 36, 39, 44, 39,  36, 39, 44, 39,  36, 39, 44, 39,  36, 39, 44, 39], 2),
	);

~leadline = Pbind(
	\instrument, \leadline,
	\dur, 2,
	\amp, 0.3,
	\len, 6,
	\midinote, Pseq([75, 74, 75, 77], 2),
);

~leadline2 = Pbind(
	\instrument, \leadline,
	\dur, 2,
	\amp, 0.1,
	\len, 6,
	\midinote, Pseq([79, 77, 79, 80], 2),
);


~bass = Pbind(
	\instrument, \bassline,
	\dur, 1,
	\amp, 0.4,
	\len, 5,
	\midinote, Pseq([60, 67, 58, 67, 56, 67, 58, 67], 2),
);

~kick = Pbind(
	\instrument, \kick,
	\dur, Pseq([1, 1, 1, 0.25, 0.25, 0.25, 0.25], 4),
);

~kickfirst = Pbind(
	\instrument, \kick,
	\dur, Pseq([15, 0.25, 0.25, 0.25, 0.25], 1),
	\freq, Pseq([\rest, 60, 60, 60, 60], 1)
);
~snaremain = Pbind(
	\instrument, \snare,
	\dur, Pseq([0.1667, 0.1666, 0.1666,
	0.1667, 0.1666, 0.1666,
	0.1667, 0.1666, 0.1666,
	0.1667, 0.1666, 0.1666,
	0.5, 1.5
	], 4),

	\amp, Pseq([0.4, 0.2, 0.2, 0.4, 0.2, 0.2, 0.4, 0.2, 0.2, 0.4, 0.2, 0.2, 0.4, 0], 4),

	\freq, Pseq([5500, 5000, 5000,
	5500, 5000, 5000,
	5500, 5000, 5000,
	5500, 5000, 5000,
	5500,
	\rest
	], 4),
);

~snare = Pbind(
	\instrument, \snare,
	\dur, Pseq([1, 1, 1, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125], 4),
	\freq, Pseq([\rest, 5500, \rest, 5500, 2200, 5500, 2200, 5500, 2200, 5500, 2200], 4),
);

~chords = Pbind(
	\instrument, \chords,
	\dur, 4,
	\midinote, Pseq([ [48, 55], [56, 63], [58, 65], [56, 63] ], 1),
	\amp, 0.3,
	\len, 16,
);

~finalchord = Pbind(
	\instrument, \chords,
	\dur, 4,
	\midinote, Pseq([ [48, 55] ], 1),
	\amp, 0.3,
	\len, 16,

);

~foundtext = Pbind(
	\instrument, \foundtext,
	\bufnum, b.bufnum,
	\dur, Pseq([16], 1),

);
)


(
Pseq([
	~arpeggio,
	Ppar([~arpeggio, ~leadline]),
	Ppar([~arpeggio, ~leadline, ~bass]),
	Ppar([ ~leadline, ~bass, ~leadline2 ]),
	Ppar([ ~bass, ~foundtext, ~kickfirst]),
	Ppar([ ~arpeggio, ~bass, ~kick, ~snare]),
	Ppar([ ~arpeggio, ~leadline, ~bass, ~kick, ~snare]),
	Ppar([ ~arpeggio, ~leadline, ~bass, ~kick, ~snare, ~leadline2]),
	Ppar([~chords, ~leadline, ~leadline2]),
	Ppar([~chords, ~leadline, ~leadline2, ~bass, ~kickfirst]),
	Ppar([~arpeggio, ~leadline, ~bass, ~kick, ~snare, ~leadline2, ~chords]),
	Ppar([~chords, ~leadline, ~leadline2, ~bass, ~arpeggio]),
	Ppar([~chords, ~bass]),
	Ppar([~chords, ~foundtext]),
	Ppar([~finalchord]),
]).play(TempoClock.new.tempo_(150/60))
) 