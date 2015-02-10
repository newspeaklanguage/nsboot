Class addSubclass: ImplementationBase class.
"So SystemNavigation/SystemScope allBehaviorsDo: can find it and subclasses.  Not sure why this is needed in Squeak 4.2 but not 3.9, possible a result of a difference in how the versions of Monticello load a class with nil superclass.  I would prefer to include this in ImplementationBase class>>initialize, but it will fail because ImplementationBase class is not a subclass of Class at the time when it is run."

ChangeSet fileIntoNewChangeSet: 'smalltalk/96-NewspeakExceptions.cs'.

ChangeSet fileIntoNewChangeSet: 'smalltalk/97-Vassilis-icons.cs'.
SystemWindow classPool
	at: #CloseBoxImage put: nil;
	at: #MenuBoxImage put: nil;
	at: #ExpandBoxImage put: nil;
	at: #CollapseBoxImage put: nil.

ChangeSet fileIntoNewChangeSet: 'smalltalk/98-HideNonSmalltalkFromMC.cs'.
"This is not part of the 03-Other set because it should come after multilanguage, otherwise attempt to determine language will fail"

"ChangeSet fileIntoNewChangeSet: 'smalltalk/95-PostPatches.cs'."

MCWorkingCopy allManagers do: [:ea | ea modified: false].
"Forget about the path to the package cache used during the bootstrap"
MCRepositoryGroup default removeRepository: MCCacheRepository default.MCCacheRepository instVarNamed: 'default' put: nil.

NewspeakGlobalState resetEverything.
NsToolSet releaseMemory: false.
Smalltalk condenseChanges. "Must be after releaseMemory: for reasons beyond me"
Smalltalk cleanUp.
NewspeakGlobalState resetEverything.
SystemOrganization removeEmptyCategories.

Smalltalk addToStartUpList: NsFFISessionManager after: Delay.
NativeSession start.

UIManager default: NativeUIManager new.
NewsqueakDockingBar setup.
SHTextStylerST80 setupForNewsqueak.

[NewspeakGlobalState platform kernel takeOver] ifError: [Transcript show: 'takeOver failed'; cr].
NsToolSet releaseMemory: false.

[|imageName|
 imageName := 'nsboot-',Date today yyyymmdd.
 SystemVersion newVersion: imageName.
 WorldState addDeferredUIMessage: [
	Smalltalk snapshot: true andQuit: true.
	Transcript clear.
	Transcript show: 'Hello, Brave New World!!'.
	Transcript cr.
	OSProcess isWindows ifFalse: [NewspeakGlobalState ide IDEWindow open].
	].
] forkAt: 19. "Fork because we want to release the file handle for this file-in before we save."

