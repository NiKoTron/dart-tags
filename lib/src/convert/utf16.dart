import 'dart:convert';

import 'package:utf/utf.dart';

class UTF16 extends Encoding {
  @override
  Converter<List<int>, String> get decoder => _UTF16Decoder();

  @override
  Converter<String, List<int>> get encoder => _UTF16Enoder();

  @override
  String get name => 'utf16';
}

class _UTF16Decoder extends Converter<List<int>, String> {
  @override
  String convert(List<int> input) {
    return decodeUtf16le(input, 0, input.length);
  }
}

class _UTF16Enoder extends Converter<String, List<int>> {
  @override
  List<int> convert(String input) {
    return input.runes.toList();
  }
}
