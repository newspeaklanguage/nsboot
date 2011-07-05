
| repository |

repository := MCDirectoryRepository	new
	directory: (FileDirectory default / 'SmalltalkPackages').	
(repository versionFromFileNamed: 'Newsqueak-mixins-ryan.92.mcz') load
