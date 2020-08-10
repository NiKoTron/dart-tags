# Framer API

Since [v0.2.0](https://github.com/NiKoTron/dart-tags/releases/tag/v0.2.0), we are using separate frame processing Framer API.

Before this version, we made all parsing inside readers\writers. But now I've separated frame processing into the standalone classes. This approach provides more modularity and ability for extending.

## Frame processors

Currently, separate frame processing implemented for these tags:

- `APIC` frame
- `COMM` frame
- `TXXX` frame
- `WXXX` frame
- `USLT` frame

Another tags proceeds through default tag processing
