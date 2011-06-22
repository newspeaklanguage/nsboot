
Smalltalk addToStartUpList: NsFFISessionManager after: Delay.
NativeSession start. 
UnversionedSourceManager srcmgr setup.
Smalltalk saveAs: 'nsboot-', Date today yyyymmdd.

"NsBoot basicNew fixDanglingReferences.
SerializationData setup.
ToolSet default: NsToolSet.
NsBoot basicNew openDockingBar.
Utilities setAuthorInitials: ''. 
NativeSession start.
Smalltalk at: #UnversionedSourceManager ifPresent: [ :srcmgr | srcmgr setup]."
