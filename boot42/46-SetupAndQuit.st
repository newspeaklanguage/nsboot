
Class addSubclass: ImplementationBase class.
"So SystemNavigation/SystemScope allBehaviorsDo: can find it and subclasses.  Not sure why this is needed in Squeak 4.2 but not 3.9, possible a result of a difference in how the versions of Monticello load a class with nil superclass.  I would prefer to include this in ImplementationBase class>>initialize, but it will fail because ImplementationBase class is not a subclass of Class at the time when it is run."

ChangeSet fileIntoNewChangeSet: '98-HideNonSmalltalkFromMC.cs'.
"This is not part of the 03-Other set because it should come after multilanguage, otherwise attempt to determine language will fail"

Platform resetEverything.
NsToolSet releaseMemory: true.
Smalltalk condenseChanges. "Must be after releaseMemory: for reasons beyond me"
Smalltalk cleanUp.
Platform resetEverything.

Smalltalk addToStartUpList: NsFFISessionManager after: Delay.
NativeSession start.
NewsqueakDockingBar setup.
UnversionedSourceManager setup.
SHTextStylerST80 setupForNewsqueak.

[Smalltalk saveAs: 'nsboot-', Date today yyyymmdd. 
 Smalltalk snapshot: true andQuit: true.] forkAt: 19.

"
SerializationData setup.
"
