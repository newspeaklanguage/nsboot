'From nsboot-2011-08-03 of 3 August 2011 [latest update: #10966] on 12 June 2012 at 9:31:11 pm'!!MultiNewParagraph methodsFor: 'fonts-display' stamp: 'yk 2/28/2012 18:27'!displayOn: aCanvas using: displayScanner at: somePosition	"Send all visible lines to the displayScanner for display"	| visibleRectangle offset leftInRun line |	lines isNil ifTrue: [^self]. "Avoiding display of an uninitialized instance, which is possible because of a race condition caused by TextMorph>>paragraph."	visibleRectangle := aCanvas clipRect.	offset := somePosition - positionWhenComposed.	leftInRun := 0.	(self lineIndexForPoint: visibleRectangle topLeft)		to: (self lineIndexForPoint: visibleRectangle bottomRight)		do: [:i | line := lines at: i.			self displaySelectionInLine: line on: aCanvas.			line first <= line last ifTrue:				[leftInRun := displayScanner displayLine: line								offset: offset leftInRun: leftInRun]].! !