
| repository |

Object subclass: #PluggableTextView
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mock'.
Object subclass: #PluggableTextController
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mock'.

repository := MCDirectoryRepository	new
	directory: (FileDirectory default / 'SmalltalkPackages').	
(repository versionFromFileNamed: 'Shout-ryan.73.mcz') load.