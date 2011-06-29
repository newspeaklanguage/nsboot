
| repository |

Object subclass: #CombinatorialParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Combinatorial Parsing'.

repository := MCDirectoryRepository	new
	directory: (FileDirectory default / 'SmalltalkPackages').	
(repository versionFromFileNamed: 'NewsqueakBase-ryan.88.mcz') load.
