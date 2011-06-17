
| repository |

repository := MCDirectoryRepository	new
	directory: (FileDirectory default / 'SmalltalkPackages').	
(repository versionFromFileNamed: 'NewsqueakBase-ryan.87.mcz') load.
