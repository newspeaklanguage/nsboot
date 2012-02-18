
| repository |

Object subclass: #ServiceProvider
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mock'.

repository := MCDirectoryRepository	new
	directory: (FileDirectory default / 'SmalltalkPackages').	
(repository loadVersionFromFileNamed: 'Newspeak-ryan.256.mcz') load.
