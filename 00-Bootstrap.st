
[
Smalltalk snapshot: true andQuit: false embedded: false.
	Utilities setAuthorInitials: 'bootstrapping'.
ChangeSet fileIntoNewChangeSet: '01-LimitedUnload.cs'.
ChangeSet fileIntoNewChangeSet: '02-LimitedUnload.cs'.
ChangeSet fileIntoNewChangeSet: '03-Other.cs'.
ChangeSet fileIntoNewChangeSet: '03-Other2.cs'.
ChangeSet fileIntoNewChangeSet: '03-Other3.cs'.
ChangeSet fileIntoNewChangeSet: '04-SetupPreferences.cs'.
ChangeSet fileIntoNewChangeSet: '06-load_NsSvnRepository.st'.
ChangeSet fileIntoNewChangeSet: '07-load_NsMultilanguage.st'.
ChangeSet fileIntoNewChangeSet: '08-load_NewsqueakBase.st'.
ChangeSet fileIntoNewChangeSet: '10-load_NsSystem.st'.
ChangeSet fileIntoNewChangeSet: '11-load_XML-Parser.st'.
ChangeSet fileIntoNewChangeSet: '13-RecreateSpecialObjectsArray.st'.
ChangeSet fileIntoNewChangeSet: '14-load_FFIKernel.st'.
ChangeSet fileIntoNewChangeSet: '15-load_OSProcess.st'.
ChangeSet fileIntoNewChangeSet: '16-load_Shout.st'.
ChangeSet fileIntoNewChangeSet: '20-PackagingCore.st'.
ChangeSet fileIntoNewChangeSet: '21-load_NewspeakFacelift.st'.
ChangeSet fileIntoNewChangeSet: '23-reload_NewsqueakBase.st'.
ChangeSet fileIntoNewChangeSet: '26-BaseEnhancements.st'.
ChangeSet fileIntoNewChangeSet: '27-SHTextStylerST80 setupForNewsqueak.st'.
ChangeSet fileIntoNewChangeSet: '29-load_Yield.st'.
ChangeSet fileIntoNewChangeSet: '30-load_NewspeakCore.st'.
ChangeSet fileIntoNewChangeSet: '32-load_Newsqueak-conversions.st'.
ChangeSet fileIntoNewChangeSet: '33-load_Newsqueak-mixins.st'.
ChangeSet fileIntoNewChangeSet: '34-load_NsFFI.st'.
ChangeSet fileIntoNewChangeSet: '36-load_Newspeak.st'.
ChangeSet fileIntoNewChangeSet: '39-load_NOFBootstrap.st'.
ChangeSet fileIntoNewChangeSet: '40-NewspeakBytecode.cs'.
ChangeSet fileIntoNewChangeSet: '43-load_INIFile-Core.st'.
ChangeSet fileIntoNewChangeSet: '44-load_Phase2Packages.st'.
	Smalltalk saveAs: 'aboutToCompileNS3.image'.
ChangeSet fileIntoNewChangeSet: '45-LoadNS3Modules.st'.
	Smalltalk saveAs: 'compiledNS3Modules.image'.
ChangeSet fileIntoNewChangeSet: '46-SetupAndQuit.st'.
	Utilities setAuthorInitials: ''.
] forkAt: 20 named: 'Bootstrapping'
