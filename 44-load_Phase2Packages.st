
| repository |

Object subclass: #TestRunner
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mock'.
	
repository := MCDirectoryRepository	new
	directory: (FileDirectory default / 'SmalltalkPackages').	
	
(repository loadVersionFromFileNamed: 'BrazilForMorphic-ryan.25.mcz') load.
(repository loadVersionFromFileNamed: 'Brazil-ryan.323.mcz') load.
(repository loadVersionFromFileNamed: 'ExternalProcess-ryan.26.mcz') load.
(repository loadVersionFromFileNamed: 'Hopscotch-ryan.274.mcz') load.
(repository loadVersionFromFileNamed: 'NativeSession-ryan.95.mcz') load.
(repository loadVersionFromFileNamed: 'NewspeakObjectFormat-ryan.37.mcz') load.
(repository loadVersionFromFileNamed: 'NewspeakSynchronization-ryan.47.mcz') load.
(repository loadVersionFromFileNamed: 'NSCollections-ryan.55.mcz') load.
(repository loadVersionFromFileNamed: 'NSFiles-ryan.29.mcz') load.
(repository loadVersionFromFileNamed: 'NsSvnRepository2-ryan.42.mcz') load.
(repository loadVersionFromFileNamed: 'NsToolSet-ryan.45.mcz') load.
(repository loadVersionFromFileNamed: 'SourceManagement-ryan.198.mcz') load.
(repository loadVersionFromFileNamed: 'VmMirror-ryan.33.mcz') load.
(repository loadVersionFromFileNamed: 'Win32API-ryan.46.mcz') load.
