/// Abstraction for image extraction
abstract class ImageExtractor {
  List<int> parse(List<int> byteData);
}

/// Abstract class that utilise SOI (start of image) and EOI (end of image)
/// patterns to determine image data in byte array
abstract class SoiEoiExtractor implements ImageExtractor {
  List<int> get soi;
  List<int> get eoi;

  @override
  List<int> parse(List<int> byteData) {
    final iter = byteData.iterator;

    var reachEOI = false;
    var reachSOI = false;

    final buff = <int>[];

    while (iter.moveNext() && !reachEOI) {
      if (reachSOI) {
        final b = iter.current;
        buff.add(b);
        if (b == eoi[0]) {
          final eoiterator = eoi.iterator..moveNext();
          var fail = false;
          while (eoiterator.moveNext() && !fail) {
            iter.moveNext();
            buff.add(iter.current);
            if (eoiterator.current != iter.current) {
              fail = true;
            }
          }
          if (!fail) {
            reachEOI = true;
            break;
          }
        }
      }

      if (!reachSOI && iter.current == soi[0]) {
        final soiterator = soi.iterator..moveNext();
        var fail = false;
        while (soiterator.moveNext() && !fail) {
          iter.moveNext();
          if (soiterator.current != iter.current) {
            fail = true;
          }
        }
        if (!fail) {
          reachSOI = true;
          buff.addAll(soi);
        }
      }
    }

    return buff;
  }
}

/// JPEG extractor realisation of SoiEoiExtractor
class JPEGImageExtractor extends SoiEoiExtractor {
  @override
  List<int> get soi => [0xFF, 0xD8];
  @override
  List<int> get eoi => [0xFF, 0xD9];
}

/// PNG extractor realisation of SoiEoiExtractor
class PNGImageExtractor extends SoiEoiExtractor {
  @override
  List<int> get soi => [
        0x89,
        0x50,
        0x4E,
        0x47,
        0x0D,
        0x0A,
        0x1A,
        0x0A,
      ];
  @override
  List<int> get eoi => [
        0x00,
        0x00,
        0x00,
        0x00,
        0x49,
        0x45,
        0x4E,
        0x44,
        0xAE,
        0x42,
        0x60,
        0x82,
      ];
}
