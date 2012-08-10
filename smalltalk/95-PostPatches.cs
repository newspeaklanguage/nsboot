|dir|
dir := (FileDirectory default / 'postpatches').
dir fileNames do: [:ea |
			 ChangeSet fileIntoNewChangeSet: (dir fullNameFor: ea)].
