[
| platform minitest testConfig testModules tester |
platform := NewspeakGlobalState platform.
minitest := (NewspeakGlobalState namespace at: #Minitest) usingPlatform: platform.
testConfig := (NewspeakGlobalState namespace at: #AllSqueakTestsConfiguration) packageTestsUsing: NewspeakGlobalState ide namespacing manifestForSqueak.
testModules := testConfig testModulesUsingPlatform: platform minitest: minitest.
tester := minitest Tester testModules: testModules asArray.
tester prepare.
[tester atEnd] whileFalse:
        [ | result |
        FileStream stdout nextPutAll: tester peekSelector; nextPutAll: '...'.
        result := tester step.
        result isError ifTrue: [FileStream stdout nextPutAll: ' error'; lf].
        result isFailure ifTrue: [FileStream stdout nextPutAll: ' failure'; lf].
        result isSuccess ifTrue: [FileStream stdout nextPutAll: ' success'; lf]].

FileStream stdout nextPutAll: (tester errors size printString, ' errors'); lf.
FileStream stdout nextPutAll: (tester failures size printString, ' failures'); lf.
FileStream stdout nextPutAll: (tester successes size printString, ' successes'); lf.
Smalltalk snapshot: false andQuit: true.
] fork.
