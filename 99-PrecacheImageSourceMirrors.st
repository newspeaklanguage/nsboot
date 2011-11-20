
[
	| time |
	time := Time millisecondsToRun: 
		[Platform ide vcs sourceMirrors mirrorLoader imageMirrorsNotCorrespondingTo: {}].
	Transcript 
		cr; 
		show: (time / 1000 / 60) asInteger printString , ' minutes'.
] forkAt: 20 named: 'Cache image source mirrors'.
