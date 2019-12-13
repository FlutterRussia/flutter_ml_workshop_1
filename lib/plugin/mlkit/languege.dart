import 'package:flutter/services.dart';

class NaturalLanguageDetector {
  static const MethodChannel _channel = const MethodChannel('ml_kit_flutter/arenum');

  static NaturalLanguageDetector instance = NaturalLanguageDetector._();

  NaturalLanguageDetector._();

  Future<String> getLanguage(String text) async {
    assert(text != null);
    return await _channel.invokeMethod('getLanguage', {'text': text}) as String;
  }
}
