
| repository |

Object subclass: #ServiceProvider
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mock'.

repository := MCDirectoryRepository	new
	directory: (FileDirectory default / 'SmalltalkPackages').	
(repository versionFromFileNamed: 'Newspeak-ryan.251.mcz') load.
