import 'dart:convert';

import 'package:convert/convert.dart';

class HEXEncoding extends Encoding {
  @override
  Converter<List<int>, String> get decoder => _HEXDecoder();
  @override
  Converter<String, List<int>> get encoder => _HEXEncoder();

  @override
  String get name => 'hex';
}

class _HEXDecoder extends Converter<List<int>, String> {
  @override
  String convert(List<int> input) => hex.encode(input);
}

class _HEXEncoder extends Converter<String, List<int>> {
  @override
  List<int> convert(String input) => hex.decode(input);
}
