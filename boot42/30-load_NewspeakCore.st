
| repository |

repository := MCDirectoryRepository	new
	directory: (FileDirectory default / 'SmalltalkPackages').	
(repository versionFromFileNamed: 'NewspeakCore-ryan.48.mcz') load.
