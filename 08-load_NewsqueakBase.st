
| repository |

"Object subclass: #CombinatorialParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Combinatorial Parsing'.
	"

repository := MCDirectoryRepository	new
	directory: (FileDirectory default / 'SmalltalkPackages').	
(repository loadVersionFromFileNamed: 'NewsqueakBase-ryan.94.mcz') load.
