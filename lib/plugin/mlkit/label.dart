import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class FirebaseVisionLabelDetector {
  static const MethodChannel _channel = const MethodChannel('ml_kit_flutter/arenum');

  static FirebaseVisionLabelDetector instance = new FirebaseVisionLabelDetector._();

  FirebaseVisionLabelDetector._() {}

  Future<List<VisionLabel>> detectFromBinary(Uint8List binary) async {
    try {
      List<dynamic> labels =
          await _channel.invokeMethod("FirebaseVisionLabelDetector#detectFromBinary", {'binary': binary});
      List<VisionLabel> ret = [];
      labels?.forEach((dynamic item) {
        print("item : $item");
        final VisionLabel label = new VisionLabel._(item);
        ret.add(label);
      });
      return ret;
    } catch (e) {
      print("Error on FirebaseVisionLabelDetector#detectFromBinary : $e");
    }
    return null;
  }

  Future<List<VisionLabel>> detectFromPath(String filepath) async {
    try {
      List<dynamic> labels =
          await _channel.invokeMethod("FirebaseVisionLabelDetector#detectFromPath", {'filepath': filepath});
      List<VisionLabel> ret = [];
      labels?.forEach((dynamic item) {
        print("item : $item");
        final VisionLabel label = new VisionLabel._(item);
        ret.add(label);
      });
      return ret;
    } catch (e) {
      print("Error on FirebaseVisionLabelDetector#detectFromPath : $e");
    }
    return null;
  }
}

// ios
// https://firebase.google.com/docs/reference/swift/firebasemlvision/api/reference/Classes/VisionLabel
class VisionLabel {
  final Map<dynamic, dynamic> _data;
  final String entityID;
  final double confidence;
  final String label;

  VisionLabel._(this._data)
      : entityID = _data['entityID'],
        confidence = _data['confidence'],
        label = _data['label'];
}
