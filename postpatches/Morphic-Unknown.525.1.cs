'From nsboot-2016-03-12 of 12 March 2016 [latest update: #15113] on 14 March 2016 at 9:40:13 pm'!!Morph methodsFor: 'event handling' stamp: 'yk 12/16/2011 14:54'!yellowButtonActivity: shiftState 	"Find me or my outermost owner that has items to add to a  	yellow button menu.  	shiftState is true if the shift was pressed.  	Otherwise, build a menu that contains the contributions from  	myself and my interested submorphs,  	and present it to the user."	| menu |	"YK - Right menu not used, use to cycle windows"	SystemWindow sendTopWindowToBack.	^ self"	self isWorldMorph		ifFalse: [| outerOwner | 			outerOwner := self outermostOwnerWithYellowButtonMenu.			outerOwner				ifNil: [^ self].			outerOwner == self				ifFalse: [^ outerOwner yellowButtonActivity: shiftState]].	Preferences inPackagedImage ifTrue:		[^self].	menu := self buildYellowButtonMenu: ActiveHand.	menu		addTitle: self externalName		icon: (self iconOrThumbnailOfSize: (Preferences tinyDisplay ifTrue: [16] ifFalse: [28])).	menu popUpInWorld: self currentWorld"! !!Morph methodsFor: 'halos and balloon help' stamp: 'vb 5/16/2012 14:17'!addHalo: evt	| halo prospectiveHaloClass |	"VB 05/16/12 -- Also see if we are in a Glue release. We don't want to set	inPackagedImage for that because it disables more than the halos."	^(Preferences inPackagedImage			or: [(Preferences valueOfPreference: #isGlueRelease) == true])		ifFalse:			[prospectiveHaloClass := Smalltalk at: self haloClass ifAbsent: [HaloMorph].			halo := prospectiveHaloClass new bounds: self worldBoundsForHalo.			halo popUpFor: self event: evt.			halo]! !!HandMorph methodsFor: 'private events' stamp: 'vb 4/18/2012 11:25'!sendEvent: anEvent focus: focusHolder clear: aBlock	"Send the event to the morph currently holding the focus, or if none to the owner of the hand. Ignore the focus for mouse wheel events (delivered as keyboard events) since those should always trickle down the morph tree to let the container scroll panes handle them."	| result |	(focusHolder notNil and: [anEvent isMouseWheelEvent not]) ifTrue:		[^self sendFocusEvent: anEvent to: focusHolder clear: aBlock].	ActiveEvent := anEvent.	result := owner processEvent: anEvent.	ActiveEvent := nil.	^result! !!MenuItemMorph methodsFor: 'events' stamp: 'vb 5/16/2012 13:57'!mouseDown: evt	"Handle a mouse down event. Menu items get activated when the mouse is over them."	"VB 05/16/12 -- Disabling the following for Glue, both development and release.	We don't want live menu editing and we do want shift-click for spawning new windows."	"evt shiftPressed ifTrue: [ ^super mouseDown: evt ]."  "enable label editing" 	evt hand newMouseFocus: owner. "Redirect to menu for valid transitions"	owner selectItem: self event: evt! !!MorphicEvent methodsFor: 'testing' stamp: 'vb 4/30/2012 14:20'!isMouseWheelEvent	"Mouse wheel scrolling events are passed on to the image as control-up/down key presses."	^false! !!KeyboardEvent methodsFor: 'testing' stamp: 'gbracha 3/14/2016 21:25'!isMouseWheelEvent   ^ self isKeystroke and: [(self controlKeyPressed or: [self commandKeyPressed])                and: [self keyValue = "up" 30 or: [self keyValue = "down" 31]]]! !!NewParagraph methodsFor: 'initialize-release' stamp: 'Unknown 8/1/2012 14:18'!initialize	self positionWhenComposed: 0 @ 0.	"[vb: workaround] Make sure the instance starts off with something	half-sensible as the lines array and does not die if anyone wants to talk to it	before lazy initialization gets around to setting up the real lines."	lines := Array with:		((TextLine start: 1 stop: 1 internalSpaces: 0 paddingWidth: 0)			rectangle: (0@0 extent: 0@0);			lineHeight: 17 baseline: 14)! !!ObjectExplorerWrapper methodsFor: 'accessing' stamp: 'autoboot 1/25/2012 11:42'!hasContents	^[item hasContentsInExplorer]		on: MessageNotUnderstood		do: [:ex| false]! !!ObjectExplorerWrapper methodsFor: 'accessing' stamp: 'autoboot 1/25/2012 11:41'!icon	"Answer a form to be used as icon"	^ Preferences visualExplorer		ifTrue: [[item iconOrThumbnailOfSize: 16]					on: MessageNotUnderstood					do: [:ex| nil]]		ifFalse: [nil]! !!PasteUpMorph methodsFor: 'as-yet-unclassified' stamp: 'yk 12/16/2011 14:01'!addStackMenuItems: menu hand: aHandMorph	"Add appropriate stack-related items to the given menu"	"YK - this part removed from image, invoking it pops up the debugger!!"	"self isStackBackground		ifTrue:			[menu add: 'card & stack...' target: self action: #presentCardAndStackMenu]"! !!PasteUpMorph methodsFor: 'as-yet-unclassified' stamp: 'yk 12/16/2011 14:48'!putUpWorldMenu: evt	"Put up a menu in response to a click on the desktop, triggered by evt."	| menu |	self bringTopmostsToFront.	evt isMouse ifTrue:		[evt yellowButtonPressed ifTrue:			[^ self yellowButtonClickOnDesktopWithEvent: evt].		evt shiftPressed ifTrue:			[Preferences inPackagedImage ifTrue:				[^self].			 ^self findWindow: evt]].	Preferences inPackagedImage ifTrue:		[^self].	"put up screen menu"	menu := self buildWorldMenu: evt.	menu addTitle: Preferences desktopMenuTitle translated.	menu popUpEvent: evt in: self.	^ menu! !!TheWorldMenu methodsFor: 'commands' stamp: 'yk 11/18/2011 15:40'!quitSession	SmalltalkImage current		snapshot: (Preferences inPackagedImage					ifTrue: [(UserDialogBoxMorph 								confirm: 'Do you really want to quit?' translated) ifFalse:									[^self].							false]					ifFalse:						[UserDialogBoxMorph 							confirm: 'Save changes before quitting?' translated 							orCancel: [^ self]							at: World center])		andQuit: true! !