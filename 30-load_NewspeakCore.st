
| repository |

repository := MCDirectoryRepository	new
	directory: (FileDirectory default / 'SmalltalkPackages').	
(repository loadVersionFromFileNamed: 'NewspeakCore-cadence.62.mcz') load.
