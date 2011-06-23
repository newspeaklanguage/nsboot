
Smalltalk addToStartUpList: NsFFISessionManager after: Delay.
NativeSession start.
UnversionedSourceManager setup.
NewsqueakDockingBar setup.
Platform resetEverything.
NsToolSet releaseMemory: true.
Smalltalk condenseChanges. "Must be after releaseMemory: for reasons beyond me"
Smalltalk cleanUp.
Platform resetEverything.
[Smalltalk saveAs: 'nsboot-', Date today yyyymmdd. 
 Smalltalk snapshot: true andQuit: true.] forkAt: 19.

"
SerializationData setup.
"
