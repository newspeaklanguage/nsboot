
"NsBoot basicNew fixDanglingReferences.
SerializationData setup.
ToolSet default: NsToolSet.
NsBoot basicNew openDockingBar.
Utilities setAuthorInitials: ''. 
NativeSession start.
Smalltalk at: #UnversionedSourceManager ifPresent: [ :srcmgr | srcmgr setup]."
