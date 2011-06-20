
| runtime platform |
runtime := NewspeakObjectFormatDeserializer	appFrom: 'BootstrapRuntimeForSqueak.nof'.
platform := runtime using: VMMirror new.
Platform nsPlatform: platform.
Platform nsPlatform bootstrap.
Platform nsPlatform: nil. 

Smalltalk saveAs: 'compiledNS3Modules.image'.
