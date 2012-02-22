
| repository |

repository := MCDirectoryRepository	new
	directory: (FileDirectory default / 'SmalltalkPackages').	
(repository loadVersionFromFileNamed: 'NOFBootstrap-ryan.22.mcz') load.
