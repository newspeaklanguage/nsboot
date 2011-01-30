"
   Licensed under the Squeak License (the ''License''); you may not use this file except in compliance with the License.  You may obtain a copy of the License at  http://www.squeak.org/SqueakLicense/
"!
'From Squeak3.9 of 7 November 2006 [latest update: #7067] on 26 February 2008 at 2:07:32 pm'!
Object subclass: #SystemMetadata
	instanceVariableNames: 'hasWeakSubclasses'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Temporary Bootstrap'!
SystemMetadata subclass: #DefiningClassMetadata
	instanceVariableNames: 'languageSlot languageData definingClass applications enclosingClass nestedClasses userData'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Temporary Bootstrap'!

!SystemMetadata methodsFor: 'accessing' stamp: 'Ahe 2/26/2008 14:02'!
initialize
	hasWeakSubclasses := false! !

!SystemMetadata class methodsFor: 'private' stamp: 'Ahe 6/11/2008 16:57'!
definingClassOrSelfOf: application "<Class> ^<Class>"
	^application! !


!DefiningClassMetadata methodsFor: 'accessing' stamp: 'Ahe 2/26/2008 14:02'!
definingClass
	"Answer the value of definingClass"

	^ definingClass! !

!DefiningClassMetadata methodsFor: 'accessing' stamp: 'Ahe 2/26/2008 14:02'!
definingClass: anObject
	"Set the value of definingClass"

	definingClass := anObject! !

!DefiningClassMetadata methodsFor: 'accessing' stamp: 'Ahe 2/26/2008 14:02'!
language
	"Store the name of the language instead of a Language object for the sake of serialization"

	languageSlot == nil ifTrue: [^nil].
	languageSlot == #Smalltalk ifTrue: [^SmalltalkLanguage new].
	languageSlot == #Newsqueak0 ifTrue: [^NewsqueakLanguage0 new].
	languageSlot == #Newsqueak1 ifTrue: [^NewsqueakLanguage1 new].
	languageSlot == #Newsqueak2 ifTrue: [^NewsqueakLanguage2 new].
	languageSlot == #Newspeak3 ifTrue: [^NewspeakLanguage3 new].
	(definingClass name , ' is missing a proper languageSlot value ') out.
	^SmalltalkLanguage new! !

!DefiningClassMetadata methodsFor: 'accessing' stamp: 'Ahe 2/26/2008 14:02'!
language: l
	l == nil ifTrue: [^languageSlot:= nil].
	l isSymbol ifTrue: [^languageSlot:= l].
	languageSlot:= l name.
	^l! !

!DefiningClassMetadata methodsFor: 'accessing' stamp: 'Ahe 2/26/2008 14:02'!
languageData
	"Answer the value of languageData"

	^ languageData! !

!DefiningClassMetadata methodsFor: 'accessing' stamp: 'Ahe 2/26/2008 14:02'!
languageData: anObject
	"Set the value of languageData"

	languageData := anObject! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

DefiningClassMetadata class
	instanceVariableNames: ''!

!DefiningClassMetadata class methodsFor: 'as yet unclassified' stamp: 'Ahe 2/26/2008 14:05'!
of: cls "<Class> ^<DefiningClassMetadata>"
	^DefiningClassMetadata new definingClass: cls! !
