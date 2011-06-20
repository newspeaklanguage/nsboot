'From Squeak4.2 of 4 February 2011 [latest update: #10966] on 20 June 2011 at 3:36:30 pm'!!BlockLocalTempCounter methodsFor: 'instruction decoding' stamp: 'bootstrapping 6/20/2011 15:24'!pushImplicitReceiverForMessage: selector "<Symbol>"	"Push Implicit Receiver for Selector bytecode."	stackPointer := stackPointer + 1! !!InstructionPrinter methodsFor: 'instruction decoding' stamp: 'GB 6/5/2008 12:35'!sendToDynamicSuperclass: selector numArgs: numArgs "<Integer>" 	self print: 'sendDynamicSuper: ', selector printString! !!InstructionPrinter methodsFor: '*NsSystem-instruction decoding' stamp: 'GB 6/12/2008 11:09'!pushExplicitOuter: n 	"Print the Push Active Context's Receiver for an outer send of aSymbol on Top Of Stack bytecode."	self print: 'pushExplicitOuter: ', n asString! !!InstructionPrinter methodsFor: '*NsSystem-instruction decoding' stamp: 'GB 10/8/2008 11:55'!pushImplicitReceiverForMessage: aSymbol 	"Print the Push Active Context's Receiver for an outer send of aSymbol on Top Of Stack bytecode."	self print: 'pushImplicitReceiverFor: ', aSymbol asString! !!InstructionStream methodsFor: 'decoding' stamp: 'GB 6/5/2008 11:48'!interpretNextInstructionFor: client 	"Send to the argument, client, a message that specifies the type of the 	next instruction."	| byte type offset method |	method := self method.  	byte := method at: pc.	type := byte // 16.  	offset := byte \\ 16.  	pc := pc+1.	"We do an inline binary search on each of the possible 16 values of type:	The old, cleaner but slowe code is retained as a comment below"	type < 8	ifTrue: [type < 4				ifTrue: [type < 2						ifTrue: [type < 1								ifTrue: ["type = 0"									^ client pushReceiverVariable: offset]								ifFalse: ["type = 1"									^ client pushTemporaryVariable: offset]]						ifFalse: [type < 3								ifTrue: ["type = 2"									^ client										pushConstant: (method literalAt: offset + 1)]								ifFalse: ["type = 3"									^ client										pushConstant: (method literalAt: offset + 17)]]]				ifFalse: [type < 6						ifTrue: [type < 5								ifTrue: ["type = 4"									^ client										pushLiteralVariable: (method literalAt: offset + 1)]								ifFalse: ["type = 5"									^ client										pushLiteralVariable: (method literalAt: offset + 17)]]						ifFalse: [type < 7								ifTrue: ["type = 6"									offset < 8										ifTrue: [^ client popIntoReceiverVariable: offset]										ifFalse: [^ client popIntoTemporaryVariable: offset - 8]]								ifFalse: ["type = 7"									offset = 0										ifTrue: [^ client pushReceiver].									offset < 8										ifTrue: [^ client												pushConstant: (SpecialConstants at: offset)].									offset = 8										ifTrue: [^ client methodReturnReceiver].									offset < 12										ifTrue: [^ client												methodReturnConstant: (SpecialConstants at: offset - 8)].									offset = 12										ifTrue: [^ client methodReturnTop].									offset = 13										ifTrue: [^ client blockReturnTop].									offset = 14 ifTrue:										[| byte2 |										 byte := method at: pc.										 pc := pc+1.										byte2 := method at: pc.										 pc := pc+1.										^client sendToDynamicSuperclass: (method literalAt: byte2 + 1)												numArgs: byte].									offset = 15 ifTrue:										[byte := method at: pc.										 pc := pc+1.										^client pushImplicitReceiverForMessage: (method literalAt: byte + 1)].									^self error: 'unusedBytecode']]]]		ifFalse: [type < 12				ifTrue: [type < 10						ifTrue: [type < 9								ifTrue: ["type = 8"									^ self										interpretExtension: offset										in: method										for: client]								ifFalse: ["type = 9 (short jumps)"									offset < 8										ifTrue: [^ client jump: offset + 1].									^ client jump: offset - 8 + 1 if: false]]						ifFalse: [type < 11								ifTrue: ["type = 10 (long jumps)"									byte := method at: pc.									pc := pc + 1.									offset < 8										ifTrue: [^ client jump: offset - 4 * 256 + byte].									^ client jump: (offset bitAnd: 3)											* 256 + byte if: offset < 12]								ifFalse: ["type = 11"									^ client										send: (Smalltalk specialSelectorAt: offset + 1)										super: false										numArgs: (Smalltalk specialNargsAt: offset + 1)]]]				ifFalse: [type = 12						ifTrue: [^ client								send: (Smalltalk specialSelectorAt: offset + 17)								super: false								numArgs: (Smalltalk specialNargsAt: offset + 17)]						ifFalse: ["type = 13, 14 or 15"							^ client								send: (method literalAt: offset + 1)								super: false								numArgs: type - 13]]]."    old code 	type=0 ifTrue: [^client pushReceiverVariable: offset].	type=1 ifTrue: [^client pushTemporaryVariable: offset].	type=2 ifTrue: [^client pushConstant: (method literalAt: offset+1)].	type=3 ifTrue: [^client pushConstant: (method literalAt: offset+17)].	type=4 ifTrue: [^client pushLiteralVariable: (method literalAt: offset+1)].	type=5 ifTrue: [^client pushLiteralVariable: (method literalAt: offset+17)].	type=6 		ifTrue: [offset<8					ifTrue: [^client popIntoReceiverVariable: offset]					ifFalse: [^client popIntoTemporaryVariable: offset-8]].	type=7		ifTrue: [offset=0 ifTrue: [^client pushReceiver].				offset<8 ifTrue: [^client pushConstant: (SpecialConstants at: offset)].				offset=8 ifTrue: [^client methodReturnReceiver].				offset<12 ifTrue: [^client methodReturnConstant: 												(SpecialConstants at: offset-8)].				offset=12 ifTrue: [^client methodReturnTop].				offset=13 ifTrue: [^client blockReturnTop].				offset>13 ifTrue: [^self error: 'unusedBytecode']].	type=8 ifTrue: [^self interpretExtension: offset in: method for: client].	type=9		ifTrue:  short jumps			[offset<8 ifTrue: [^client jump: offset+1].			^client jump: offset-8+1 if: false].	type=10 		ifTrue:  long jumps			[byte:= method at: pc.  pc:= pc+1.			offset<8 ifTrue: [^client jump: offset-4*256 + byte].			^client jump: (offset bitAnd: 3)*256 + byte if: offset<12].	type=11 		ifTrue: 			[^client 				send: (Smalltalk specialSelectorAt: offset+1) 				super: false				numArgs: (Smalltalk specialNargsAt: offset+1)].	type=12 		ifTrue: 			[^client 				send: (Smalltalk specialSelectorAt: offset+17) 				super: false				numArgs: (Smalltalk specialNargsAt: offset+17)].	type>12		ifTrue: 			[^client send: (method literalAt: offset+1) 					super: false					numArgs: type-13]"! !!InstructionStream methodsFor: 'private' stamp: 'bootstrapping 6/20/2011 14:40'!interpretExtension: offset in: method for: client	| type offset2 byte2 byte3 byte4 |	offset <= 6 ifTrue: 		["Extended op codes 128-134"		byte2 := method at: pc. pc := pc + 1.		offset <= 2 ifTrue:			["128-130:  extended pushes and pops"			type := byte2 // 64.			offset2 := byte2 \\ 64.			offset = 0 ifTrue: 				[type = 0 ifTrue: [^client pushReceiverVariable: offset2].				type = 1 ifTrue: [^client pushTemporaryVariable: offset2].				type = 2  ifTrue: [^client pushConstant: (method literalAt: offset2 + 1)].				type = 3 ifTrue: [^client pushLiteralVariable: (method literalAt: offset2 + 1)]].			offset = 1 ifTrue: 				[type = 0 ifTrue: [^client storeIntoReceiverVariable: offset2].				type = 1 ifTrue: [^client storeIntoTemporaryVariable: offset2].				type = 2 ifTrue: [self error: 'illegalStore'].				type = 3 ifTrue: [^client storeIntoLiteralVariable: (method literalAt: offset2 + 1)]].			offset = 2 ifTrue: 				[type = 0 ifTrue: [^client popIntoReceiverVariable: offset2].				type = 1 ifTrue: [^client popIntoTemporaryVariable: offset2].				type = 2 ifTrue: [self error: 'illegalStore'].				type = 3  ifTrue: [^client popIntoLiteralVariable: (method literalAt: offset2 + 1)]]].		"131-134: extended sends"		offset = 3 ifTrue:  "Single extended send"			[^client send: (method literalAt: byte2 \\ 32 + 1)					super: false numArgs: byte2 // 32].		offset = 4 ifTrue:    "Double extended do-anything"			[byte3 := method at: pc. pc := pc + 1.			type := byte2 // 32.			type = 0 ifTrue: [^client send: (method literalAt: byte3 + 1)									super: false numArgs: byte2 \\ 32].			type = 1 ifTrue: [^client send: (method literalAt: byte3 + 1)									super: true numArgs: byte2 \\ 32].			type = 2 ifTrue: [^client pushReceiverVariable: byte3].			type = 3 ifTrue: [^client pushConstant: (method literalAt: byte3 + 1)].			type = 4 ifTrue: [^client pushLiteralVariable: (method literalAt: byte3 + 1)].			type = 5 ifTrue: [^client storeIntoReceiverVariable: byte3].			type = 6 ifTrue: [^client popIntoReceiverVariable: byte3].			type = 7 ifTrue: [^client storeIntoLiteralVariable: (method literalAt: byte3 + 1)]].		offset = 5 ifTrue:  "Single extended send to super"			[^client send: (method literalAt: byte2 \\ 32 + 1)					super: true numArgs: byte2 // 32].		offset = 6 ifTrue:   "Second extended send"			[^client send: (method literalAt: byte2 \\ 64 + 1)					super: false numArgs: byte2 // 64]].	offset = 7 ifTrue: [^client doPop].	offset = 8 ifTrue: [^client doDup].	offset = 9 ifTrue: [^client pushActiveContext].	byte2 := method at: pc. pc := pc + 1.	offset = 10 ifTrue:		[^byte2 < 128			ifTrue: [client pushNewArrayOfSize: byte2]			ifFalse: [client pushConsArrayWithElements: byte2 - 128]].	offset = 11 ifTrue: "139: pushExplicitOuter"		[^client pushExplicitOuter: (method literalAt: byte2 + 1)].	byte3 := method at: pc.  pc := pc + 1.	offset = 12 ifTrue: [^client pushRemoteTemp: byte2 inVectorAt: byte3].	offset = 13 ifTrue: [^client storeIntoRemoteTemp: byte2 inVectorAt: byte3].	offset = 14 ifTrue: [^client popIntoRemoteTemp: byte2 inVectorAt: byte3].	"offset = 15"	byte4 := method at: pc.  pc := pc + 1.	^client		pushClosureCopyNumCopiedValues: (byte2 bitShift: -4)		numArgs: (byte2 bitAnd: 16rF)		blockSize: (byte3 * 256) + byte4! !!InstructionStream methodsFor: 'private' stamp: 'bootstrapping 6/20/2011 14:36'!nextPc: currentByte	"Answer the pc of the next bytecode following the current one, given the current bytecode.."	| type |	type := currentByte // 16.	^type = 7		ifTrue:			[(currentByte >= 126 and: [currentByte <= 127]) "dynamic super - malplaced at 126"				ifTrue: [pc + 2]				ifFalse: [pc + 1]]		ifFalse:			[type = 8 "extensions"					ifTrue: [pc + (#(2 2 2 2 3 2 2 1 1 1 2 1 3 3 3 4) at: currentByte \\ 16 + 1)]					ifFalse: [type = 10 "long jumps"								ifTrue: [pc + 2]								ifFalse: [pc + 1]]]! !!InstructionStream methodsFor: '*NsSystem-instruction decoding' stamp: 'eem 6/20/2011 14:54'!pushExplicitOuter: n "<Integer>"	self subclassResponsibility! !!InstructionStream methodsFor: '*NsSystem-instruction decoding' stamp: 'Ahe 5/2/2008 01:31'!pushImplicitReceiverForMessage: selector "<Symbol>" 	self subclassResponsibility! !!InstructionStream methodsFor: '*NsSystem-instruction decoding' stamp: 'eem 6/20/2011 14:54'!sendToDynamicSuperclass: selector numArgs: numArgs "<Integer>" 	self subclassResponsibility! !!ContextPart methodsFor: 'controlling' stamp: 'bootstrapping 6/20/2011 15:08'!activateMethod: newMethod withArgs: args receiver: rcvr	"Answer a ContextPart initialized with the arguments."	^MethodContext 		sender: self		receiver: rcvr		method: newMethod		arguments: args! !!ContextPart methodsFor: 'controlling' stamp: 'bootstrapping 6/20/2011 15:09'!send: selector to: rcvr with: args lookupIn: lookupClass	"Simulate the action of sending a message with selector, selector, and 	arguments, args, to receiver. The argument, lookupClass, is the class in	which to lookup the message.  This is the receiver's class for normal messages,	but for super messages it will be some specific class related to the source method."	| meth val |	meth := lookupClass lookupSelector: selector.	meth == nil ifTrue:		[^self send: #doesNotUnderstand:				to: rcvr				with: (Array with: (Message selector: selector arguments: args))				lookupIn: lookupClass].	val := self tryPrimitiveFor: meth				receiver: rcvr				args: args.	val == PrimitiveFailToken ifFalse: [^ val].	(selector == #doesNotUnderstand: and: [lookupClass == ProtoObject]) ifTrue:		[^ self error: 'Simulated message ' , (args at: 1) selector , ' not understood'].	^self		activateMethod: meth		withArgs: args		receiver: rcvr! !!ContextPart methodsFor: 'controlling' stamp: 'bootstrapping 6/20/2011 15:11'!send: selector to: rcvr with: args super: superFlag 	"Simulate the action of sending a message with selector, selector, and 	arguments, args, to receiver. The argument, superFlag, tells whether the 	receiver of the message was specified with 'super' in the source method."	^self		send: selector		to: rcvr		with: args		lookupIn: (superFlag					ifTrue: [(self method literalAt: self method numLiterals) value superclass]					ifFalse: [rcvr class])! !!ContextPart methodsFor: 'controlling' stamp: 'eem 7/5/2007 11:18'!sendAttemptToAssign: value to: assignee withIndex: index	self push: assignee.	self push: value.	self push: index.	^self send: #attemptToAssign:withIndex: super: false numArgs: 2! !!ContextPart methodsFor: 'instruction decoding' stamp: 'GB 6/5/2008 12:46'!sendToDynamicSuperclass: selector numArgs: numArgs "<Integer>" 		"Simulate the action of bytecodes that send a message with selector, 	selector to the dynamic superclass. The arguments 	of the message are found in the top numArgs locations on the stack and 	the receiver just below them."	| receiver arguments answer |	arguments := Array new: numArgs.	numArgs to: 1 by: -1 do: [ :i | arguments at: i put: self pop].	receiver := self pop.	selector == #doPrimitive:method:receiver:args:		ifTrue: [answer := receiver 					doPrimitive: (arguments at: 1)					method: (arguments at: 2)					receiver: (arguments at: 3)					args: (arguments at: 4).				self push: answer.				^self].	^self		send: selector		to: receiver		with: arguments		lookupIn: (self dynamicSuperClassOfReceiver: receiver)! !!ContextPart methodsFor: '*NsSystem-private' stamp: 'GB 6/5/2008 12:46'!dynamicSuperClassOfReceiver: rcvr "<Object> ^ <Class>"   ^(self findApplicationOfTargetMixin: self methodClass            startingAtBehavior: rcvr class) superclass! !!ContextPart methodsFor: '*NsSystem-instruction decoding' stamp: 'GB 6/12/2008 13:28'!pushExplicitOuter: n "<Integer>"	| explicitReceiver |	explicitReceiver := self							explicitOuterReceiver: n							withObject: self receiver							withMixin: self methodClass.	self assert:[explicitReceiver isNil not].	self push: explicitReceiver! !!ContextPart methodsFor: '*NsSystem-instruction decoding' stamp: 'eem 4/28/2008 11:43'!pushImplicitReceiverForMessage: selector "<Symbol>"	| implicitReceiverOrNil |	implicitReceiverOrNil := self							implicitReceiverFor: self receiver							withMixin: self methodClass							implementing: selector.	self push: (implicitReceiverOrNil == nil					ifTrue: [self receiver]					ifFalse: [implicitReceiverOrNil])! !!Decompiler methodsFor: '*NsSystem-instruction decoding' stamp: 'GB 6/12/2008 13:28'!pushExplicitOuter: n "<Integer>"	stack addLast: (ExplicitOuterNode new depth: n)! !!Decompiler methodsFor: '*NsSystem-instruction decoding' stamp: 'Ahe 5/2/2008 01:11'!pushImplicitReceiverForMessage: selector "<Symbol>" 	stack addLast: (ImplicitVariableNode new name: 'outer'; selector: selector)! !!Decompiler methodsFor: '*NsSystem-instruction decoding' stamp: 'GB 6/10/2008 16:08'!sendToDynamicSuperclass: selector "<Symbol>" numArgs: numArgs "<Integer>"| args |	args := Array new: numArgs.	(numArgs to: 1 by: -1) do:		[:i | args at: i put: stack removeLast].	stack removeLast. "remove receiver, which is self" 	stack addLast:  (DynamicSuperSendNode new arguments: args; selector: selector)! !ContextPart removeSelector: #lexicalClass!!ContextPart reorganize!('accessing' at: at:put: basicAt: basicAt:put: basicSize client contextForLocalVariables home method methodNode methodNodeFormattedAndDecorated: methodReturnContext receiver size tempAt: tempAt:put:)('controlling' activateMethod:withArgs:receiver: activateMethod:withArgs:receiver:class: blockCopy: closureCopy:copiedValues: hasSender: jump pop push: quickSend:to:with:super: restart resume resume: return return: return:to: runUntilErrorOrReturnFrom: send:to:with:lookupIn: send:to:with:super: sendAttemptToAssign:to:withIndex: terminate terminateTo: top)('debugger access' contextStack depthBelow: errorReportOn: longStack methodClass namedTempAt: namedTempAt:put: pc print:on: release releaseTo: selector sender shortStack singleRelease sourceCode stack stackOfSize: swapSender: tempNames tempsAndValues tempsAndValuesLimitedTo:indent:)('instruction decoding' doDup doPop jump: jump:if: methodReturnConstant: methodReturnReceiver methodReturnTop popIntoLiteralVariable: popIntoReceiverVariable: popIntoRemoteTemp:inVectorAt: popIntoTemporaryVariable: pushActiveContext pushClosureCopyNumCopiedValues:numArgs:blockSize: pushConstant: pushLiteralVariable: pushNewArrayOfSize: pushReceiver pushReceiverVariable: pushRemoteTemp:inVectorAt: pushTemporaryVariable: return:from: send:super:numArgs: sendToDynamicSuperclass:numArgs: storeIntoLiteralVariable: storeIntoReceiverVariable: storeIntoRemoteTemp:inVectorAt: storeIntoTemporaryVariable:)('objects from disk' storeDataOn:)('printing' printDetails: printOn: trace)('query' bottomContext copyStack copyTo: findContextSuchThat: findSecondToOldestSimilarSender findSimilarSender hasContext: isBottomContext isClosureContext isContext isDead secondFromBottom)('system simulation' completeCallee: quickStep runSimulated:contextAtEachStep: step stepToCallee stepToSendOrReturn)('private' activateReturn:value: cannotReturn:to: copyTo:blocks: cut: doPrimitive:method:receiver:args: insertSender: privSender: push:fromIndexable: stackPtr stackp: tryNamedPrimitiveIn:for:withArgs: tryPrimitiveFor:receiver:args:)('private-debugger' cachesStack)('private-exceptions' canHandleSignal: findNextHandlerContextStarting findNextUnwindContextUpTo: handleSignal: isHandlerContext isUnwindContext nextHandlerContext rearmHandlerDuring: unwindTo:)('mirror primitives' object:basicAt: object:basicAt:put: object:eqeq: object:instVarAt: object:instVarAt:put: object:perform:withArguments:inClass: objectClass: objectSize:)('*NsSystem-private' dynamicSuperClassOfReceiver: enclosingMixinOf: enclosingObjectOf: explicitOuterReceiver:withObject:withMixin: explicitOuterReceiverForName:withObject:withMixin: findApplicationOfTargetMixin:startingAtBehavior: findApplicationOfTargetMixin:startingAtNonMetaClass: implicitReceiverFor:withMixin:implementing: isInterestedIn: mixinOf: nextImplicitReceiverFor:withMixin:implementing:)('*NsSystem-instruction decoding' pushExplicitOuter: pushImplicitReceiverForMessage: theImplicitReceiverForMessage:)!