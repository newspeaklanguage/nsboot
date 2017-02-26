'From Squeak5.1 of 23 August 2016 [latest update: #16548] on 25 February 2017 at 4:56:41 pm'!Object subclass: #NewspeakBootstrap	instanceVariableNames: ''	classVariableNames: ''	poolDictionaries: ''	category: 'NewspeakBootstrap'!"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!NewspeakBootstrap class	instanceVariableNames: ''!!NewspeakBootstrap class methodsFor: 'as yet unclassified' stamp: 'gbracha 2/25/2017 16:39'!boot	Utilities setAuthorInitials: 'bootstrapping'.	"Ensure that preempting a process puts it to the head of its run queue,	 instead of Blue Book Behavior."	Smalltalk vmParameterAt: 48 put: ((Smalltalk vmParameterAt: 48) bitOr: 2r100).	"This first change helps (filehandlelimits) suppress issues with running 	 out of file-handles.  This can happen if your limit is	 low (1024) and 	 Monticello is examing overrides on packages, where it will make a 	 copy of the source file streams for each method."	self loadChangeset: 'filehandlelimits.1.cs'.	self report: 'Removing packages' during: [self shrink].	self setupPreferences.	"Sadly there are loading order dependencies here."	self loadPackage: 'Newspeak-gbracha.284.mcz'.	self loadChangeset: '97-Vassilis-icons.cs'.	self loadPackage: 'Brazil-ryan.323.mcz'.	self loadPackage: 'BrazilForMorphic-rmacnak.38.mcz'.	self loadPackage: 'ExternalProcess-rmacnak.32.mcz'.	self loadPackage: 'OSProcess-rmacnak.13.mcz'.	self loadPackage: 'NsFFI-rmacnak.42.mcz'.	self loadPackage: 'NSFiles-ryan.30.mcz'.	self loadPackage: 'NativeSession-gbracha.108.mcz'.	"Broken by Squeak 5.1.         self loadPackage: 'Shout-bwesterg.75.mcz'."	self loadPackage: 'Win32API-ryan.46.mcz'.	self loadPackage: 'XML-Parser-bwesterg.16.mcz'.	self loadPackage: 'Hopscotch-tessi.276.mcz'.	self loadPackage: 'INIFile-Core-ryan.2.mcz'.	self loadPackage: 'VictoryFuel-rmacnak.3.mcz'.	self loadChangeset: 'Collections-eem.426.1.cs'.	self loadChangeset: 'enclose-newspeak-comments.2.cs'.	self loadChangeset: 'Exceptions-bwesterg.33.1.cs'.	self loadChangeset: 'ExternalUnixOSProcess-update.st'.	self loadChangeset: 'Initials.1.cs'.	self loadChangeset: 'Files-eem.101.1.cs'.	self loadChangeset: 'Morphic-Unknown.525.1.cs'.	self loadChangeset: 'System-eem.424.1.cs'.	self loadChangeset: 'Tools-eem.300.3.cs'.	CompiledMethod installSecondaryBytecodeSet: EncoderForNewsqueakV4.	"Allows Newspeak to subclass Smalltalk."	Object addSelectorSilently: #'initializer`new' withMethod: CompiledMethod toReturnSelf.	"For Alien"	Smalltalk recreateSpecialObjectsArray.	"The fun part."	self loadNewspeakModules.	self loadResources. 	"So SystemNavigation/SystemScope allBehaviorsDo: can find it and subclasses.  Not sure why this is needed in Squeak 4.2 but not 3.9, possible a result of a difference in how the versions of Monticello load a class with nil superclass.  I would prefer to include this in ImplementationBase class>>initialize, but it will fail because ImplementationBase class is not a subclass of Class at the time when it is run."	Class addSubclass: ImplementationBase class.	MCWorkingCopy allManagers do: [:ea | ea modified: false].	"Forget about the path to the package cache used during the bootstrap"	MCRepositoryGroup default removeRepository: MCCacheRepository default.	MCCacheRepository instVarNamed: 'default' put: nil.		Smalltalk cleanUp.	SystemOrganization removeEmptyCategories.	Smalltalk addToStartUpList: NsFFISessionManager after: Delay.	NativeSession start.	UIManager default: NativeUIManager new.	NewsqueakDockingBar setup.	SHTextStylerST80 setupForNewsqueak.		NewspeakGlobalState resetEverything.	[NewspeakGlobalState platform kernel takeOver]		ifError: [Transcript show: 'takeOver failed'; cr].        "Broken in Squeak 5.1.	 SystemVersion newVersion: 'nsboot-',Date today yyyymmdd."	Utilities setAuthorInitials: ''.	WorldState addDeferredUIMessage: 		[Smalltalk snapshot: true andQuit: true.		 Transcript clear.		 Transcript show: 'Hello, Brave New World!!'; cr.		 OSProcess isWindows ifFalse: [NewspeakGlobalState ide IDEWindow open]].! !!NewspeakBootstrap class methodsFor: 'as yet unclassified' stamp: 'Unknown 8/7/2012 15:16'!cr
	Transcript cr.
	FileStream stdout lf.! !!NewspeakBootstrap class methodsFor: 'as yet unclassified' stamp: 'rmacnak 4/29/2015 21:17'!exit: status
	<primitive: 113>
	self primitiveFailed! !!NewspeakBootstrap class methodsFor: 'as yet unclassified' stamp: 'rmacnak 4/29/2015 21:54'!initialize
	WorldState addDeferredUIMessage:
		[[self boot] on: Error do:
			[:error |
			"Stupid Squeak error that does nothing when unhandled."
			error class = InvalidDirectoryError ifTrue: [error pass].
			self print: (String streamContents: [:stm | error signalerContext errorReportOn: stm]); cr.
			self exit: 1]].! !!NewspeakBootstrap class methodsFor: 'as yet unclassified' stamp: 'ryan 8/7/2012 21:50'!loadChangeset: filename
	self report: 'Loading changeset ', filename during:
		[ChangeSet fileIntoNewChangeSet: 
			(FileDirectory default / 'smalltalk' fullNameFor: filename)].! !!NewspeakBootstrap class methodsFor: 'as yet unclassified' stamp: 'rmacnak 3/20/2014 20:12'!loadNewspeakModules
	| runtime platform repoDir files |
        TheWorldMainDockingBar instance closeAllWindows.
	Transcript open.
	self
                report: 'Deserializing bootstrap runtime'
                during:
                        [StandardFileStream oldFileNamed: 'BootstrapRuntimeForSqueak.vfuel' do: [:stream |
                        | deserializer |
                        deserializer := VFDeserializer new over: stream binary withGlobals: Smalltalk globals.
                        runtime := deserializer deserialize]].
        self
                report: 'Instantiating bootstrap runtime'
	        during: [platform := runtime using: VMMirror new].
        NewspeakGlobalState platform: platform.
        
	repoDir := (FileDirectory default containingDirectory / 'newspeak').
	files := repoDir fileNames select: [:ea | ea endsWith: '.ns'].
	files sort: [:a :b | a < b].
	files do: [:ea | 
		self report: 'Compiling module ', ea during:
			[ | fn src builder mixinMirror klass |
                        fn := repoDir fullNameFor: ea.
                        src := (CrLfFileStream readOnlyFileNamed: fn) contentsOfEntireFile.
                        builder := platform mirrors ClassDeclarationBuilder fromUnitSource: src.
                        klass := builder install reflectee apply: platform kernel Object withName: builder name.
                        NewspeakGlobalState namespace at: klass name put: klass]].
	
	NewspeakGlobalState resetEverything.! !!NewspeakBootstrap class methodsFor: 'as yet unclassified' stamp: 'ryan 8/7/2012 21:48'!loadPackage: filename
	self report: 'Loading package ', filename during:
		[ | repository |
		repository := MCDirectoryRepository new
			directory: (FileDirectory default / 'smalltalk').	
		(repository loadVersionFromFileNamed: filename) load].! !!NewspeakBootstrap class methodsFor: 'as yet unclassified' stamp: 'rmacnak 3/20/2014 20:21'!loadResources
	| repoDir files |
	repoDir := (FileDirectory default containingDirectory / 'newspeak').
	files := repoDir fileNames select: [:ea | ea endsWith: '.png'].
	files sort: [:a :b | a < b].
	files do: [:ea | 
		self report: 'Loading resource ', ea during:
			[ | name form |
			form := PNGReadWriter formFromFileNamed: (repoDir fullNameFor: ea).
			name := (ea allButLast: 4) asSymbol.
			NewspeakGlobalState namespace at: name put: form]].
	
	NewspeakGlobalState resetEverything.! !!NewspeakBootstrap class methodsFor: 'as yet unclassified' stamp: 'ryan 8/7/2012 21:58'!print: string
	Transcript nextPutAll: string; flush.
	FileStream stdout nextPutAll: string.! !!NewspeakBootstrap class methodsFor: 'as yet unclassified' stamp: 'eliot 10/3/2014 09:25'!report: message during: block
	| time |
	self print: message.
	time := block timeToRun.
	self print: '. Done in ', time printString, ' ms.'.
        self cr.! !!NewspeakBootstrap class methodsFor: 'as yet unclassified' stamp: 'rmacnak 8/15/2015 14:26'!setupPreferences	
	Preferences setPreference: #swapMouseButtons toValue: true.
	Preferences setPreference: #extraDebuggerButtons toValue: true.
	Preferences setPreference: #diffsWithPrettyPrint toValue: true.
	Preferences setPreference: #annotationPanes toValue: true.
	Preferences setPreference: #multipleTextUndo toValue: true.
	Preferences setPreference: #diffsWithPrettyPrint toValue: false.
	Preferences setPreference: #syntaxHighlightingAsYouTypeAnsiAssignment toValue: true.
	Preferences setPreference: #fullScreenLeavesDeskMargins toValue: false.
	Preferences setPreference: #scrollBarsWithoutMenuButton toValue: true.
	Preferences setPreference: #scrollBarsNarrow toValue: false.
	Preferences enable: #alwaysShowVScrollbar.

	ScrollBar scrollBarsWithoutArrowButtons: false.
	
	Morph indicateKeyboardFocus: false.
	
	TextEditor autoEnclose: false.
	
	Preferences 
		addBooleanPreference: #experimental 
		category: 'Newspeak' 
		default: false 
		balloonHelp: 'Help?'.

	Preferences 
		addBooleanPreference: #allowDebugger 
		category: 'Newspeak' 
		default: true 
		balloonHelp: 'Help?'.
		
	Preferences 
		addBooleanPreference: #inPackagedImage 
		category: 'Newspeak' 
		default: false
		balloonHelp: 'Help?'.

	Scanner prefAllowUnderscoreSelectors: true.! !!NewspeakBootstrap class methodsFor: 'as yet unclassified' stamp: 'rmacnak 8/15/2015 14:28'!shrink
	"This is 'Smalltalk shrink' with broken parts removed."
	Smalltalk zapMVCprojects.
	Flaps disableGlobalFlaps: false.
	"Smalltalk unloadReloadablePackages."
	Smalltalk cleanUp: true.
	SystemOrganization removeSystemCategory: 'UserObjects'.
	Smalltalk garbageCollect.! !NewspeakBootstrap initialize!