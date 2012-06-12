
| repository |

repository := MCDirectoryRepository	new
	directory: (FileDirectory default / 'SmalltalkPackages').	
(repository loadVersionFromFileNamed: 'NsSystem-cadence.52.mcz') load.
