
| repository |

Object subclass: #TestRunner
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mock'.
	
repository := MCDirectoryRepository	new
	directory: (FileDirectory default / 'SmalltalkPackages').	
	
(repository loadVersionFromFileNamed: 'BrazilForMorphic-ryan.24.mcz') load.
(repository loadVersionFromFileNamed: 'Brazil-ryan.322.mcz') load.
(repository loadVersionFromFileNamed: 'ExternalProcess-ryan.25.mcz') load.
(repository loadVersionFromFileNamed: 'Hopscotch-ryan.274.mcz') load.
(repository loadVersionFromFileNamed: 'NativeSession-ryan.94.mcz') load.
(repository loadVersionFromFileNamed: 'NewspeakObjectFormat-ryan.36.mcz') load.
(repository loadVersionFromFileNamed: 'NewspeakSynchronization-ryan.46.mcz') load.
(repository loadVersionFromFileNamed: 'NSCollections-ryan.55.mcz') load.
(repository loadVersionFromFileNamed: 'NSFiles-ryan.29.mcz') load.
(repository loadVersionFromFileNamed: 'NsSvnRepository2-ryan.42.mcz') load.
(repository loadVersionFromFileNamed: 'NsToolSet-ryan.44.mcz') load.
(repository loadVersionFromFileNamed: 'SourceManagement-ryan.198.mcz') load.
(repository loadVersionFromFileNamed: 'VmMirror-ryan.33.mcz') load.
(repository loadVersionFromFileNamed: 'Win32API-ryan.46.mcz') load.
