
| runtime platform |
runtime := NewspeakObjectFormatDeserializer appFrom: 'BootstrapRuntimeForSqueak.nof'.
platform := runtime using: VMMirror new.
BlackMarket platform: platform.
BlackMarket platform bootstrap.
BlackMarket resetEverything.
