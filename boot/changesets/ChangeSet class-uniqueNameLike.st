"
   Licensed under the Squeak License (the ''License''); you may not use this file except in compliance with the License.  You may obtain a copy of the License at  http://www.squeak.org/SqueakLicense/
"!
'From nsboot-2008-04-30.00 of 30 April 2008 [latest update: #0] on 1 May 2008 at 12:33:11 pm'!!ChangeSet class methodsFor: 'defaults' stamp: 'Ahe 5/1/2008 12:32'!uniqueNameLike: aString	| try |	(self named: aString) ifNil: [^ aString].	1 to: 999999 do:		[:i | try := aString, '.', i printString.		(self named: try) ifNil: [^ try]]! !