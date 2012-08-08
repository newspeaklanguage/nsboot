|dir|
dir := (FileDirectory default / 'CadencePatches').
dir fileNames do: [:ea |
			 ChangeSet fileIntoNewChangeSet: (dir fullNameFor: ea)].
