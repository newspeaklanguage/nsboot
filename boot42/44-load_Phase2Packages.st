
| repository |

Object subclass: #TestRunner
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mock'.
	
repository := MCDirectoryRepository	new
	directory: (FileDirectory default / 'SmalltalkPackages').	
	
(repository versionFromFileNamed: 'BrazilForMorphic-ryan.23.mcz') load.
(repository versionFromFileNamed: 'Brazil-ryan.322.mcz') load.
(repository versionFromFileNamed: 'ExternalProcess-ryan.25.mcz') load.
(repository versionFromFileNamed: 'Hopscotch-ryan.272.mcz') load.
(repository versionFromFileNamed: 'NativeSession-ryan.85.mcz') load.
(repository versionFromFileNamed: 'NewspeakObjectFormat-ryan.36.mcz') load.
(repository versionFromFileNamed: 'NewspeakSynchronization-ryan.46.mcz') load.
(repository versionFromFileNamed: 'NSCollections-ryan.55.mcz') load.
(repository versionFromFileNamed: 'NSFiles-ryan.29.mcz') load.
(repository versionFromFileNamed: 'NsSvnRepository2-ryan.42.mcz') load.
(repository versionFromFileNamed: 'NsToolSet-ryan.35.mcz') load.
(repository versionFromFileNamed: 'SourceManagement-ryan.196.mcz') load.
(repository versionFromFileNamed: 'VmMirror-ryan.33.mcz') load.
(repository versionFromFileNamed: 'Win32API-ryan.46.mcz') load.

Smalltalk saveAs: 'aboutToCompileNS3.image'.