[
| stdout platform minitest testConfig testModules tester redError |
stdout := FileStream stdout.
stdout lineEndConvention: nil.
red := (String value: 27),'[31m'.
yellow := (String value: 27),'[33m'.
clearColor := (String value: 27),'[39m'.
clearLine := (String value: 27),'[K'.

platform := NewspeakGlobalState platform.
minitest := (NewspeakGlobalState namespace at: #Minitest) usingPlatform: platform.
testConfig := (NewspeakGlobalState namespace at: #AllSqueakTestsConfiguration) packageTestsUsing: NewspeakGlobalState ide namespacing manifestForSqueak.
testModules := testConfig testModulesUsingPlatform: platform minitest: minitest.
tester := minitest Tester testModules: testModules asArray.
tester prepare.
[tester atEnd] whileFalse:
        [ | result |
        stdout nextPutAll: tester peekSelector; nextPutAll: '...'.
        result := tester step.
        result isError ifTrue: [stdout nextPutAll: red; nextPutAll: ' error'; nextPutAll: clearColor; lf].
        result isFailure ifTrue: [stdout nextPutAll: yellow; nextPutAll: ' failure'; nextPutAll: clearColor; lf].
        result isSuccess ifTrue: [stdout nextPutAll: ' success'; cr; nextPutAll: clearLine]].

stdout nextPutAll: red.
stdout nextPutAll: (tester errors size printString, ' errors'); lf.
tester errors do: [:result | stdout space; nextPutAll: result testCase selector; lf].
stdout nextPutAll: clearColor.

stdout nextPutAll: yellow.
stdout nextPutAll: (tester failures size printString, ' failures'); lf.
tester failures do: [:result | stdout space; nextPutAll: result testCase selector; lf].
stdout nextPutAll: clearColor.

stdout nextPutAll: (tester successes size printString, ' successes'); lf.

Smalltalk snapshot: false andQuit: true.
] fork.
