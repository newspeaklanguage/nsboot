
Smalltalk addToStartUpList: NsFFISessionManager after: Delay.
NativeSession start.
UnversionedSourceManager setup.
NewsqueakDockingBar setup.
[Smalltalk saveAs: 'nsboot-', Date today yyyymmdd.] forkAt: 19.

"NsBoot basicNew fixDanglingReferences.
SerializationData setup.
ToolSet default: NsToolSet.
NsBoot basicNew openDockingBar.
Utilities setAuthorInitials: ''. 
NativeSession start.
Smalltalk at: #UnversionedSourceManager ifPresent: [ :srcmgr | srcmgr setup]."
