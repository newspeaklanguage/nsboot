
| repository |

repository := MCDirectoryRepository	new
	directory: (FileDirectory default / 'SmalltalkPackages').	
(repository loadVersionFromFileNamed: 'OSProcess-ryan.11.mcz') load.
"(repository versionFromFileNamed: 'OSProcess-dtl.63.mcz') load."
