'From nsboot-2013-01-07 of 7 January 2013 [latest update: #11860] on 8 January 2013 at 2:14:49 pm'!!TextEditor methodsFor: 'editing keys' stamp: 'btw 1/8/2013 14:13'!encloseNewspeakComment: aKeyboardEvent	"Insert or remove bracket characters around the current selection."	| begin end startIndex stopIndex oldSelection t |	begin := '(*'.	end := '*)'.	self closeTypeIn.	startIndex := self startIndex.	stopIndex := self stopIndex.	oldSelection := self selection.	t := self text.	((startIndex > 2 and: [stopIndex <= t size]) and: 	[(t at: startIndex-1) = $* and: [(t at: stopIndex) = $*]])		ifTrue: [			"already enclosed; strip off brackets"			self selectFrom: startIndex-begin size to: stopIndex+begin size-1.			self replaceSelectionWith: oldSelection]		ifFalse: [			"not enclosed; enclose by matching brackets"			self replaceSelectionWith:				(Text string: begin, oldSelection string, end attributes: emphasisHere).			self selectFrom: startIndex+2 to: stopIndex+1].	^true! !!TextEditor class methodsFor: 'keyboard shortcut tables' stamp: 'btw 1/8/2013 13:43'!initializeShiftCmdKeyShortcuts 	"Initialize the shift-command-key (or control-key) shortcut table."	"NOTE: if you don't know what your keyboard generates, use Sensor kbdTest"	"wod 11/3/1998: Fix setting of cmdMap for shifted keys to actually use the 	capitalized versions of the letters.	TPR 2/18/99: add the plain ascii values back in for those VMs that don't return the shifted values."	"TextEditor initialize"		| cmdMap cmds |	"shift-command and control shortcuts"	cmdMap := Array new: 256 withAll: #noop:.  		"use temp in case of a crash"	cmdMap at: ( 1 + 1) put: #cursorHome:.			"home key"	cmdMap at: ( 4 + 1) put: #cursorEnd:.				"end key"	cmdMap at: ( 8 + 1) put: #forwardDelete:.			"ctrl-H or delete key"	cmdMap at: (11 + 1) put: #cursorPageUp:.			"page up key"	cmdMap at: (12 + 1) put: #cursorPageDown:.		"page down key"	cmdMap at: (13 + 1) put: #crWithIndent:.			"ctrl-Return"	cmdMap at: (27 + 1) put: #offerMenuFromEsc:.	"escape key"	cmdMap at: (28 + 1) put: #cursorLeft:.			"left arrow key"	cmdMap at: (29 + 1) put: #cursorRight:.			"right arrow key"	cmdMap at: (30 + 1) put: #cursorUp:.				"up arrow key"	cmdMap at: (31 + 1) put: #cursorDown:.			"down arrow key"	cmdMap at: (32 + 1) put: #selectWord:.			"space bar key"	cmdMap at: (45 + 1) put: #changeEmphasis:.		"cmd-sh-minus"	cmdMap at: (61 + 1) put: #changeEmphasis:.		"cmd-sh-plus"	cmdMap at: (127 + 1) put: #forwardDelete:.		"del key"	"On some keyboards, these characters require a shift"	'([<{|"''9' do: [:char | cmdMap at: char asciiValue + 1 put: #enclose:].	"Newspeak comments"	cmdMap at: $* asciiValue + 1 put: #encloseNewspeakComment:.		"NB: sw 12/9/2001 commented out the idiosyncratic line just below, which was grabbing shift-esc in the text editor and hence which argued with the wish to have shift-esc be a universal gesture for escaping the local context and calling up the desktop menu."  	"cmdMap at: (27 + 1) put: #shiftEnclose:." 	"ctrl-["	"'""''(' do: [ :char | cmdMap at: (char asciiValue + 1) put: #enclose:]."	cmds := #(		$c	compareToClipboard:		$d	duplicate:		$h	cursorTopHome:		$j	doAgainMany:		$k	changeStyle:		$l	outdent:		$m	selectCurrentTypeIn:		$r	indent:		$s	search:		$u	changeLfToCr:		$x	makeLowercase:		$y	makeUppercase:		$z	makeCapitalized:	).	1 to: cmds size by: 2 do: [ :i |		cmdMap at: ((cmds at: i) asciiValue + 1) put: (cmds at: i + 1).			"plain keys"		cmdMap at: ((cmds at: i) asciiValue - 32 + 1) put: (cmds at: i + 1).		"shifted keys"		cmdMap at: ((cmds at: i) asciiValue - 96 + 1) put: (cmds at: i + 1).		"ctrl keys"	].	shiftCmdActions := cmdMap! !!TextEditor reorganize!('menu messages' accept again align browseChangeSetsWithSelector browseClassFromIt browseIt browseItHere cancel changeAlignment chooseAlignment classCommentsContainingIt classNamesContainingIt compareToClipboard copySelection cut exchange explain fileItIn find findAgain implementorsOfIt methodNamesContainingIt methodSourceContainingIt methodStringsContainingit pasteRecent prettyPrint prettyPrint: prettyPrintWithColor referencesToIt saveContentsInFile selectedSelector selectedSymbol sendersOfIt setAlignment: setSearchString spawn undo)('new selection' afterSelectionInsertAndSelect: correctFrom:to:with: encompassLine: insertAndSelect:at: lineSelectAndEmptyCheck: nextTokenFrom:direction: notify:at:in: selectFrom:to: selectLine selectPrecedingIdentifier)('private' againOnce: againOrSame: againOrSame:many: applyAttribute: beginningOfLine: completeSymbol:lastOffering: endOfLine: exchangeWith: indent:fromStream:toStream: isDisjointFrom: moveCursor:forward:event:specialBlock: nullText pageHeight resetTypeAhead sameColumn:newLine:forward: typeAhead unapplyAttribute:)('editing keys' abandonChangeText align: browseIt: browseItHere: cancel: changeEmphasis: changeLfToCr: chooseColor compareToClipboard: copyHiddenInfo doIt: duplicate: emphasisExtras enclose: encloseNewspeakComment: exchange: exploreIt: fileItIn: handleEmphasisExtra:with: hiddenInfo implementorsOfIt: inOutdent:delta: indent: inspectIt: makeCapitalized: makeLowercase: makeUppercase: methodNamesContainingIt: methodStringsContainingIt: offerFontMenu: outdent: pasteInitials: printIt: referencesToIt: save: sendersOfIt: setEmphasis: spawnIt: swapChars: undo:)('typing/selecting keys' argAdvance: changeStyle: crWithIndent: destructiveBackWord: displayIfFalse: displayIfTrue: doAgainMany: doAgainOnce: find: findAgain: forwardDelete: querySymbol: search: tabCount)('typing support' addString: backTo: closeTypeIn dispatchOnEnterWith: dispatchOnKeyboardEvent: doneTyping insertAndCloseTypeIn insertTypeAhead openTypeIn setEmphasisHere setEmphasisHereFromText setEmphasisHereFromTextForward: startOfTyping)('binding' bindingOf:)('parenblinking' blinkParen blinkParenAt: blinkPrevParen: clearParens)('attributes' changeEmphasisOrAlignment changeSelectionFontTo: changeStyle changeTextFont offerFontMenu)('initialize-release' changeParagraph: resetState stateArray stateArrayPut:)('do-its' compileSelectionFor:in: debug:receiver:in: debugIt doIt evaluateSelection evaluateSelectionAndDo: exploreIt inspectIt printIt)('nonediting/nontyping keys' cursorEnd: cursorHome: raiseContextMenu: selectCurrentTypeIn: setSearchString:)('explain' explainAnySel: explainChar: explainClass: explainCtxt: explainDelimitor: explainGlobal: explainInst: explainMySel: explainNumber: explainPartSel: explainScan: explainTemp:)('displaying' flash)('accessing-selection' hasCaret markIndex markIndex:pointIndex: pointIndex selection selectionAsStream startBlock startIndex stopBlock stopIndex unselect)('undo support' isDoing isRedoing isUndoing noUndoer undoMessage:forRedo: undoer: undoer:with: undoer:with:with: undoer:with:with:with:)('model access' model:)('events' keyStroke: mouseDown: mouseMove: mouseUp: yellowButtonDown:)('menu commands' offerMenuFromEsc:)('current selection' recomputeSelection reverseSelection selectAndScroll)('accessing' model paragraph replace:with:and: replaceSelectionWith: setSearch: string styler styler: text totalTextHeight transformFrom: visibleHeight)('scrolling' scrollBy: updateMarker)('mvc compatibility' storeSelectionInParagraph zapSelectionWith:)('undoers' undoAgain:andReselect:typedKey: undoAndReselect:redoAndReselect: undoCutCopy: undoQuery:lastOffering: undoReplace)('as-yet-unclassified')!"Postscript:We need to initialize the editors again."Editor initialize.!