import 'dart:convert';
import 'dart:core';

import 'package:utf_convert/utf_convert.dart' as utf;

abstract class UTF16 extends Encoding {
  List<int> get bom;

  static const le = [0xff, 0xfe];
  static const be = [0xfe, 0xff];

  @override
  Converter<List<int>, String> get decoder;

  @override
  Converter<String, List<int>> get encoder;

  @override
  String get name; // => 'utf16';
}

class UTF16LE extends UTF16 {
  @override
  List<int> get bom => UTF16.le;

  @override
  Converter<List<int>, String> get decoder => _UTF16LEDecoder();

  @override
  Converter<String, List<int>> get encoder => _UTF16LEEncoder();

  @override
  String get name => 'utf16le';
}

class _UTF16LEDecoder extends Converter<List<int>, String> {
  @override
  String convert(List<int> input) {
    final decoder = utf.Utf16leBytesToCodeUnitsDecoder(input);
    return String.fromCharCodes(decoder.decodeRest());
  }
}

class _UTF16LEEncoder extends Converter<String, List<int>> {
  @override
  List<int> convert(String input) {
    return utf.encodeUtf16le(input, true);
  }
}

class UTF16BE extends UTF16 {
  @override
  List<int> get bom => UTF16.be;

  @override
  Converter<List<int>, String> get decoder => _UTF16BEDecoder();

  @override
  Converter<String, List<int>> get encoder => _UTF16BEEncoder();

  @override
  String get name => 'utf16be';
}

class _UTF16BEDecoder extends Converter<List<int>, String> {
  @override
  String convert(List<int> input) {
    final decoder = utf.Utf16beBytesToCodeUnitsDecoder(input);
    return String.fromCharCodes(decoder.decodeRest());
  }
}

class _UTF16BEEncoder extends Converter<String, List<int>> {
  @override
  List<int> convert(String input) {
    return utf.encodeUtf16be(input, true);
  }
}
