
| repository |

repository := MCDirectoryRepository	new
	directory: (FileDirectory default / 'SmalltalkPackages').	
(repository versionFromFileNamed: 'OSProcess-ryan.10.mcz') load.
