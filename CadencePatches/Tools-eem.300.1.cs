'From nsboot-2011-08-03 of 3 August 2011 [latest update: #10966] on 7 August 2012 at 11:21:03 am'!!DebuggerMethodMapForClosureCompiledMethods methodsFor: 'as-yet-unclassified' stamp: 'eem 11/4/2011 11:09'!privateDereference: tempReference in: aContext	"Fetch the temporary with reference tempReference in aContext.	 tempReference can be		integer - direct temp reference		#( indirectionVectorIndex tempIndex ) - remote temp in indirectionVector at index		#( outer. temp reference ) - a temp reference in an outer context."	^tempReference isInteger		ifTrue: [aContext tempAt: tempReference]		ifFalse:			[tempReference first == #outer				ifTrue:					[self privateDereference: tempReference last						in: aContext outerContext]				ifFalse: "Cope with nil indirection vectors, scne they may be uncreated early in method execution"					[([aContext tempAt: tempReference first]							on: Error							do: [:ex| nil])						ifNotNil:							[:indirectionVector| indirectionVector at: tempReference second]]]! !!StringHolder methodsFor: '*Tools' stamp: 'nice 3/14/2010 19:43'!fileOutAllMessages	"Put a description of the all the message list on a file."	FileStream		writeSourceCodeFrom:			(String new: 16000 streamContents: [:str |				self messageList do: [:e |					e actualClass printMethodChunk: e methodSymbol withPreamble: true					on: str moveSource: false toFile: 0]])		baseName: (self messageListSelectorTitle replaceAll: Character space with: $_) isSt: true useHtml: false! !!StringHolder methodsFor: '*Tools' stamp: 'nice 3/14/2010 19:43'!fileOutMessage	"Put a description of the selected message on a file.	If no message is selected, put a description of ALL the message list."	self selectedMessageName		ifNil:			[self fileOutAllMessages]		ifNotNil:			[Cursor write showWhile:				[self selectedClassOrMetaClass fileOutMethod: self selectedMessageName]]! !!CodeHolder methodsFor: 'message list' stamp: 'eem 9/27/2011 08:52'!decompiledSourceIntoContentsWithTempNames: showTempNames 	"Obtain a source string by decompiling the method's code, and place 	that source string into my contents.	Also return the string.	Get temps from source file if showTempNames is true."	| tempNames class selector method |	class := self selectedClassOrMetaClass.	selector := self selectedMessageName.	"Was method deleted while in another project?"	method := class compiledMethodAt: selector ifAbsent: [^ ''].	currentCompiledMethod := method.	(showTempNames not	 or: [method fileIndex > 0 and: [(SourceFiles at: method fileIndex) isNil]])		ifTrue:			"Emergency or no source file -- decompile without temp names "			[contents := (class decompilerClass new							decompile: selector							in: class							method: method methodForDecompile) decompileString]		ifFalse:			[tempNames := (class newCompiler									parse: method getSourceFromFile asString									in: class									notifying: nil)										generate: CompiledMethodTrailer defaultMethodTrailer;										schematicTempNamesString.			contents := ((class decompilerClass new withTempNames: tempNames)							decompile: selector							in: class							method: method methodForDecompile) decompileString].	contents := contents asText makeSelectorBoldIn: class.	^ contents copy! !!ChangeList methodsFor: 'scanning' stamp: 'eem 6/20/2012 17:06'!scanCategory: category class: class meta: meta stamp: stamp	| itemPosition method selector firstLine untypedSignature |	[itemPosition := file position.	method := file nextChunk.	file skipStyleChunk.	method size > 0]	whileTrue:			"done when double terminators"		[firstLine := method copyUpTo: $= "i.e. the = in foo = (...) in a Newspeak method def".		 ((firstLine occurrencesOf: $<) > 0		  and: [(firstLine occurrencesOf: $<) = (firstLine occurrencesOf: $>)])			ifTrue: [untypedSignature := String streamContents:						[:s| | inType |						inType := false.						firstLine do:							[:c|							inType								ifTrue: [c == $> ifTrue: [inType := false]]								ifFalse:									[c = $< ifTrue: [inType := true] ifFalse: [s nextPut: c]]]]]			ifFalse: [untypedSignature := method].		 self addItem: (ChangeRecord new file: file position: itemPosition type: #method							class: class category: category meta: meta stamp: stamp)			text: 'method: ' , class , (meta ifTrue: [' class '] ifFalse: [' '])				, ((selector := (Smalltalk at: class ifAbsent: [Object]) parserClass new parseSelector: untypedSignature) isNil					ifTrue: ['unparsableSelector']					ifFalse: [selector])				, (stamp isEmpty ifTrue: [''] ifFalse: ['; ' , stamp])]! !!ChangeList methodsFor: 'as-yet-unclassified' stamp: 'eem 11/2/2011 11:51'!scanCategory  	"Scan anything that involves more than one chunk; method name is historical only"	| itemPosition item tokens methodsForIndex stamp |	itemPosition := file position.	item := file nextChunk.	((item includesSubString: 'commentStamp:')	or: [(item includesSubString: 'methodsFor:')	or: [item endsWith: 'reorganize']]) ifFalse:		["Maybe a preamble, but not one we recognize; bail out with the preamble trick"		^ self addItem: (ChangeRecord new file: file position: itemPosition type: #preamble)				 text: ('preamble: ' , item contractTo: 50)].	tokens := Scanner new scanTokens: item.	(tokens size >= 3	 and: [(methodsForIndex :=  tokens indexOf: #methodsFor:) > 1]) ifTrue:		[stamp := (tokens indexOf: #stamp: ifAbsent: [nil])						ifNotNil: [:stampIndex| tokens at: (stampIndex + 1)]						ifNil: [''].		(tokens at: methodsForIndex - 1) == #class ifTrue:			[^self scanCategory: (tokens at: methodsForIndex + 1)					class: (methodsForIndex = 3 "A simple name or not?"								ifTrue: [tokens first]								ifFalse: [((tokens copyFrom: 1 to: methodsForIndex - 2) fold: [:a :b| a, b]) asSymbol])					meta: true					stamp: stamp].		^ self scanCategory: (tokens at: methodsForIndex + 1)				class: (methodsForIndex = 2 "A simple name or not?"							ifTrue: [tokens first]							ifFalse: [((tokens copyFrom: 1 to: methodsForIndex - 1) fold: [:a :b| a, b]) asSymbol])				meta: false				stamp: stamp].	tokens second == #commentStamp:		ifTrue:			[stamp := tokens third.			self addItem:					(ChangeRecord new file: file position: file position type: #classComment									class: tokens first category: nil meta: false stamp: stamp)					text: 'class comment for ' , tokens first, 						  (stamp isEmpty ifTrue: [''] ifFalse: ['; ' , stamp]).			file nextChunk.			^ file skipStyleChunk].	self assert: tokens last == #reorganize.	self addItem:		(ChangeRecord new			file: file position: file position type: #reorganize			class: tokens first category: nil meta: false stamp: stamp)		text: 'organization for ' , tokens first, (tokens second == #class ifTrue: [' class'] ifFalse: ['']).	file nextChunk! !