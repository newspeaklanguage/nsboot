
| repository |

repository := MCDirectoryRepository	new
	directory: (FileDirectory default / 'SmalltalkPackages').	
(repository versionFromFileNamed: 'NsMultilanguage-ryan.59.mcz') load.
