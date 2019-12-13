import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';

class VisionText {
  final Map<dynamic, dynamic> _data;

  String get text => _data['text'];
  final Rect rect;
  final List<Point<num>> cornerPoints;

  VisionText._(this._data)
      : rect = Rect.fromLTRB(_data['rect_left'], _data['rect_top'], _data['rect_right'], _data['rect_bottom']),
        cornerPoints = _data['points'] == null
            ? null
            : _data['points'].map<Point<num>>((dynamic item) => Point<num>(item['x'], item['y'])).toList();
}

class VisionTextBlock extends VisionText {
  final List<VisionTextLine> lines;

  VisionTextBlock._(Map<dynamic, dynamic> data)
      : lines = data['lines'] == null
            ? null
            : data['lines'].map<VisionTextLine>((dynamic item) => VisionTextLine._(item)).toList(),
        super._(data);
}

class VisionTextLine extends VisionText {
  final List<VisionTextElement> elements;

  VisionTextLine._(Map<dynamic, dynamic> data)
      : elements = data['elements'] == null
            ? null
            : data['elements'].map<VisionTextElement>((dynamic item) => VisionTextElement._(item)).toList(),
        super._(data);
}

class VisionTextElement extends VisionText {
  VisionTextElement._(Map<dynamic, dynamic> data) : super._(data);
}

class FirebaseMlkit {
  static const MethodChannel _channel = const MethodChannel('ml_kit_flutter/arenum');

  static FirebaseMlkit instance = new FirebaseMlkit._();

  FirebaseMlkit._() {}

  FirebaseVisionTextDetector getVisionTextDetector() {
    return FirebaseVisionTextDetector.instance;
  }
}

class FirebaseVisionTextDetector {
  static const MethodChannel _channel = const MethodChannel('ml_kit_flutter/arenum');

  static FirebaseVisionTextDetector instance = new FirebaseVisionTextDetector._();

  FirebaseVisionTextDetector._() {}

  Future<List<VisionText>> detectFromBinary(Uint8List binary) async {
    List<dynamic> texts =
        await _channel.invokeMethod("FirebaseVisionTextDetector#detectFromBinary", {'binary': binary});
    List<VisionText> ret = [];
    texts?.forEach((dynamic item) {
      final VisionTextBlock text = new VisionTextBlock._(item);
      ret.add(text);
    });
    return ret;
  }

  Future<List<VisionText>> detectFromPath(String filepath) async {
    /// Step 8
    /// Реализуем бриджинг между Flutter и нативной платформой.
    /// У `_channel` который реализован выше существует метод `invokeMethod` принимающий: [название метода] и
    /// [аргументы].
    ///
    /// Прошу заметить что вся работа с нативной платформой должна выполнятся асинхронно!
    ///
    /// После того как нам вернулся от ML список нам нужно его распарсить и вернуть [List<VisionText>].
    List<dynamic> texts =
        await _channel.invokeMethod("FirebaseVisionTextDetector#detectFromPath", {'filepath': filepath});
    List<VisionText> ret = [];
    texts?.forEach((dynamic item) {
      final VisionTextBlock text = new VisionTextBlock._(item);
      ret.add(text);
    });
    return ret;
  }
}
