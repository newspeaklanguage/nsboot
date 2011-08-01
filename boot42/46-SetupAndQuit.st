
Class addSubclass: ImplementationBase class.
"So SystemNavigation/SystemScope allBehaviorsDo: can find it and subclasses.  Not sure why this is needed in Squeak 4.2 but not 3.9, possible a result of a difference in how the versions of Monticello load a class with nil superclass.  I would prefer to include this in ImplementationBase class>>initialize, but it will fail because ImplementationBase class is not a subclass of Class at the time when it is run."

ChangeSet fileIntoNewChangeSet: '96-NewspeakExceptions.cs'.

ChangeSet fileIntoNewChangeSet: '97-Vassilis-icons.cs'.
SystemWindow classPool
	at: #CloseBoxImage put: nil;
	at: #MenuBoxImage put: nil;
	at: #ExpandBoxImage put: nil;
	at: #CollapseBoxImage put: nil.

ChangeSet fileIntoNewChangeSet: '98-HideNonSmalltalkFromMC.cs'.
"This is not part of the 03-Other set because it should come after multilanguage, otherwise attempt to determine language will fail"

MCWorkingCopy allManagers do: [:ea | ea modified: false].

Platform resetEverything.
NsToolSet releaseMemory: true.
Smalltalk condenseChanges. "Must be after releaseMemory: for reasons beyond me"
Smalltalk cleanUp.
Platform resetEverything.
SystemOrganization removeEmptyCategories.

Smalltalk addToStartUpList: NsFFISessionManager after: Delay.
NativeSession start.

UIManager default: NativeUIManager new.
NewsqueakDockingBar setup.
"UnversionedSourceManager setup."
SHTextStylerST80 setupForNewsqueak.

[|imageName|
 imageName := 'nsboot-',Date today yyyymmdd.
 SystemVersion newVersion: imageName.
 Smalltalk saveAs: imageName. 
 WorldState addDeferredUIMessage: [
	Smalltalk snapshot: true andQuit: true.
	Transcript clear.
	Transcript show: 'Hello, Brave New World!!'.
	Transcript cr.
	OSProcess isWindows ifFalse: [Platform ide IDEWindow open]].
] forkAt: 19. "Fork because we want to release the file handle for this file-in before we save."

"
SerializationData setup.
"
