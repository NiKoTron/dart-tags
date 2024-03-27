/// Abstraction for image extraction
abstract class ImageExtractor {
  List<int> parse(List<int> byteData);
}

/// Abstract class that utilise SOI (start of image) and EOI (end of image)
/// patterns to determine image data in byte array
abstract class SoiEoiExtractor implements ImageExtractor {
  List<int> get soi;
  List<int> get eoi;

  bool isBytesInData(List<int> data, List<int> bytes, int offset) {
    for (var index = 0; index < bytes.length; index++) {
      if ((offset + index) > (data.length - 1)) {
        return false;
      }

      if (data[offset + index] != bytes[index]) {
        return false;
      }
    }
    return true;
  }

  @override
  List<int> parse(List<int> byteData) {
    var soiIndex = 0;
    var eoiIndex = 0;

    for (var index = 0; index < byteData.length; index++) {
      if (byteData[index] == soi[0]) {
        if (isBytesInData(byteData, soi, index)) {
          soiIndex = index;
          break;
        }
      }
    }

    for (var index = byteData.length - 1; index >= 0; index--) {
      if (byteData[index] == eoi[0]) {
        if (isBytesInData(byteData, eoi, index)) {
          eoiIndex = index + eoi.length;
          break;
        }
      }
    }

    return byteData.sublist(soiIndex, eoiIndex);
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
