'From nsboot-2011-08-03 of 3 August 2011 [latest update: #10966] on 7 August 2012 at 11:16:28 am'!!InvalidDirectoryError methodsFor: 'accessing' stamp: 'bwesterg 5/25/2012 15:07'!messageText		(messageText == nil and: [pathName ~= nil])		ifTrue: [messageText := pathName].	^super messageText! !