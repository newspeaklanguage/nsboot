'From nsboot-2014-03-17 of 17 March 2014 [latest update: #11860] on 20 March 2014 at 8:30:20 pm'!
Object subclass: #NewspeakBootstrap
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'NewspeakBootstrap'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

NewspeakBootstrap class
	instanceVariableNames: ''!

!NewspeakBootstrap class methodsFor: 'as yet unclassified' stamp: 'rmacnak 3/20/2014 20:30'!
boot
	"Force a save to avoid dialog about incompatibility of JIT-saved images with pre-JIT VMs."
	Smalltalk snapshot: true andQuit: false embedded: false.

	Utilities setAuthorInitials: 'bootstrapping'.
	"Ensure that preempting a process puts it to the head of its run queue,
	 instead of Blue Book Behavior."
	Smalltalk vmParameterAt: 48 put: ((Smalltalk vmParameterAt: 48) bitOr: 2r100).
	"This first change helps (filehandlelimits) supress issues with running 
	 out of file-handles.  This can happen if your limit is	 low (1024) and 
	 Monticello is examing overrides on packages, where it will make a 
	 copy of the source file streams for each method."
	self loadChangeset: 'filehandlelimits.1.cs'.
	self loadChangeset: '01-LimitedUnload.cs'.
	self loadChangeset: '02-LimitedUnload.cs'.
	self loadChangeset: '03-Other.cs'.
	self loadChangeset: '03-Other2.cs'.
	self loadChangeset: '03-Other3.cs'.
	self loadChangeset: '04-SetupPreferences.cs'.
	self loadPackage: 'Tests-eliot.140.mcz'.
	self loadPackage: 'NsMultilanguage-rmacnak.89.mcz'.
	self loadPackage: 'NewsqueakBase-rmacnak.98.mcz'.
	self loadPackage: 'NsSystem-rmacnak.67.mcz'.
	self loadPackage: 'XML-Parser-bwesterg.16.mcz'.
	self loadChangeset: '13-RecreateSpecialObjectsArray.st'.
	self loadPackage: 'FFI-Kernel-ryan.9.mcz'.
	self loadPackage: 'OSProcess-rmacnak.12.mcz'.
	self loadPackage: 'Shout-bwesterg.75.mcz'.
	self loadChangeset: '20-PackagingCore.st'.
	self loadPackage: 'NewspeakFacelift-ryan.8.mcz'.
	self loadChangeset: '26-BaseEnhancements.st'.
	self loadChangeset: '27-SHTextStylerST80 setupForNewsqueak.st'.
	self loadPackage: 'NewspeakCore-rmacnak.81.mcz'.
	self loadPackage: 'Newsqueak-mixins-rmacnak.109.mcz'.
	self loadPackage: 'NsFFI-rmacnak.39.mcz'.
	self loadPackage: 'Newspeak-rmacnak.258.mcz'.
	self loadPackage: 'NOFBootstrap-rmacnak.36.mcz'.
	self loadChangeset: '40-NewspeakBytecode.cs'.
	self loadPackage: 'INIFile-Core-ryan.2.mcz'.
	self loadPackage: 'BrazilForMorphic-rmacnak.35.mcz'.
	self loadPackage: 'Brazil-ryan.323.mcz'.
	self loadPackage: 'ExternalProcess-rmacnak.31.mcz'.
	"Supress monticello load warnings for the Network package. 
	 It has been maked dirty as a side-effect of changesets above.
	 This particular version has the version of UUID class>>#String:
	 that we need."
	[self loadPackage: 'Network-bwesterg.141.mcz'] on: Warning do: [:ex | ex resume].
	self loadPackage: 'Hopscotch-tessi.276.mcz'.
	self loadPackage: 'NativeSession-rmacnak.104.mcz'.
	self loadPackage: 'NSCollections-ryan.55.mcz'.
	self loadPackage: 'NSFiles-ryan.30.mcz'.
	self loadPackage: 'NsToolSet-rmacnak.51.mcz'.
	self loadPackage: 'Win32API-ryan.46.mcz'.
	
	self loadChangeset: '95-PostPatches.cs'.
	
	(MCWorkingCopy allManagers select:
		[:wc | #('Compiler*' 'Kernel*' 'System*' 'Files*') anySatisfy: 
			[:pat| pat match: wc package name]]) 
				do: [:wc| wc modified: false].	
	self loadPackage: 'Files-eliot.119.mcz'.
	self loadPackage: 'System.spur-rmacnak.474.mcz'.
	Smalltalk recreateSpecialObjectsArray.
	self loadPackage: 'Compiler.spur.newspeak-rmacnak.245.mcz'.
	"EncoderForNewsqueakV4 is the alternate instruction set but isn't installed
	 in CompiledMethod's class vars yet.  CompiledMethod will complain that
	 methods with the alternate set's flag alreayd exist.  Squash te warning."
	[CompiledMethod installSecondaryBytecodeSet: EncoderForNewsqueakV4]
		on: Warning
		do: [:ex| ex resume].
	self loadPackage: 'Kernel.spur.newspeak-rmacnak.685.mcz'.

	self loadNewspeakModules.
	self loadResources.

	self loadChangeset: '46-SetupAndQuit.st'.
	
	Utilities setAuthorInitials: ''.! !

!NewspeakBootstrap class methodsFor: 'as yet unclassified' stamp: 'Unknown 8/7/2012 15:16'!
cr
	Transcript cr.
	FileStream stdout lf.! !

!NewspeakBootstrap class methodsFor: 'as yet unclassified' stamp: 'Unknown 8/7/2012 14:38'!
initialize
	[WorldState addDeferredUIMessage: [self boot]] forkAt: 20 named: 'Bootstrapping'! !

!NewspeakBootstrap class methodsFor: 'as yet unclassified' stamp: 'ryan 8/7/2012 21:50'!
loadChangeset: filename
	self report: 'Loading changeset ', filename during:
		[ChangeSet fileIntoNewChangeSet: 
			(FileDirectory default / 'smalltalk' fullNameFor: filename)].! !

!NewspeakBootstrap class methodsFor: 'as yet unclassified' stamp: 'rmacnak 3/20/2014 20:12'!
loadNewspeakModules
	| runtime platform repoDir files |
	Transcript open.
	self
                report: 'Deserializing bootstrap runtime'
                during: [runtime := NewspeakObjectFormatDeserializer appFrom: 'BootstrapRuntimeForSqueak.nof'].
        self
                report: 'Instantiating bootstrap runtime'
	        during: [platform := runtime using: VMMirror new].
        NewspeakGlobalState platform: platform.
        
	repoDir := (FileDirectory default containingDirectory / 'newspeak').
	files := repoDir fileNames select: [:ea | ea endsWith: '.ns3'].
	files := files sortBy: [:a :b | a < b].
	files do: [:ea | 
		self report: 'Compiling module ', ea during:
			[ | fn src builder mixinMirror klass |
                        fn := repoDir fullNameFor: ea.
                        src := (CrLfFileStream readOnlyFileNamed: fn) contentsOfEntireFile.
                        builder := platform mirrors ClassDeclarationBuilder fromUnitSource: src.
                        klass := builder install reflectee apply: platform kernel Object withName: builder simpleName.
                        NewspeakGlobalState namespace at: klass name put: klass]].
	
	NewspeakGlobalState resetEverything.! !

!NewspeakBootstrap class methodsFor: 'as yet unclassified' stamp: 'ryan 8/7/2012 21:48'!
loadPackage: filename
	self report: 'Loading package ', filename during:
		[ | repository |
		repository := MCDirectoryRepository new
			directory: (FileDirectory default / 'smalltalk').	
		(repository loadVersionFromFileNamed: filename) load].! !

!NewspeakBootstrap class methodsFor: 'as yet unclassified' stamp: 'rmacnak 3/20/2014 20:21'!
loadResources
	| repoDir files |
	repoDir := (FileDirectory default containingDirectory / 'newspeak').
	files := repoDir fileNames select: [:ea | ea endsWith: '.png'].
	files := files sortBy: [:a :b | a < b].
	files do: [:ea | 
		self report: 'Loading resource ', ea during:
			[ | name form |
			form := PNGReadWriter formFromFileNamed: (repoDir fullNameFor: ea).
			name := (ea allButLast: 4) asSymbol.
			NewspeakGlobalState namespace at: name put: form]].
	
	NewspeakGlobalState resetEverything.! !

!NewspeakBootstrap class methodsFor: 'as yet unclassified' stamp: 'ryan 8/7/2012 21:58'!
print: string
	Transcript nextPutAll: string; flush.
	FileStream stdout nextPutAll: string.! !

!NewspeakBootstrap class methodsFor: 'as yet unclassified' stamp: 'eliot 10/3/2014 09:25'!
report: message during: block
	| time |
	self print: message.
	time := block timeToRun.
	self print: '. Done in ', ((time / 10) ceiling / 100.0) printString, ' seconds.'.
        self cr.! !


NewspeakBootstrap initialize!
