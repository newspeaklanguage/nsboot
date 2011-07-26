
| repository |

"Object subclass: #CombinatorialParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Combinatorial Parsing'.
	"

repository := MCDirectoryRepository	new
	directory: (FileDirectory default / 'SmalltalkPackages').	
(repository versionFromFileNamed: 'NewsqueakBase-ryan.91.mcz') load.
