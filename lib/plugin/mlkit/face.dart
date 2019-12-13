import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';

class VisionFaceDetectorOptions {
  final VisionFaceDetectorClassification classificationType;
  final VisionFaceDetectorMode modeType;
  final VisionFaceDetectorLandmark landmarkType;
  final double minFaceSize;
  final bool isTrackingEnabled;

  VisionFaceDetectorOptions(
      {this.classificationType: VisionFaceDetectorClassification.None,
      this.modeType: VisionFaceDetectorMode.Fast,
      this.landmarkType: VisionFaceDetectorLandmark.None,
      this.minFaceSize: 0.1,
      this.isTrackingEnabled: false});

  Map<String, dynamic> asDictionary() {
    return {
      "classificationType": classificationType.value,
      "modeType": modeType.value,
      "landmarkType": landmarkType.value,
      "minFaceSize": minFaceSize,
      "isTrackingEnabled": isTrackingEnabled,
    };
  }
}

class VisionFaceDetectorClassification {
  final int value;

  const VisionFaceDetectorClassification._(int value) : value = value;

  static const None = const VisionFaceDetectorClassification._(1);
  static const All = const VisionFaceDetectorClassification._(2);
}

class VisionFaceDetectorMode {
  final int value;

  const VisionFaceDetectorMode._(int value) : value = value;
  static const Fast = const VisionFaceDetectorMode._(1);
  static const Accurate = const VisionFaceDetectorMode._(2);
}

class VisionFaceDetectorLandmark {
  final int value;
  const VisionFaceDetectorLandmark._(int value) : value = value;
  static const None = const VisionFaceDetectorLandmark._(1);
  static const All = const VisionFaceDetectorLandmark._(2);
}

class VisionFaceLandmark {
  final FaceLandmarkType type;
  final VisionPoint position;

  VisionFaceLandmark._(Map<dynamic, dynamic> data)
      : type = FaceLandmarkType._(data['type']),
        position = VisionPoint._(data['position']);
}

// ios
//   https://firebase.google.com/docs/reference/ios/firebasemlvision/api/reference/Classes/FIRVisionPoint
class VisionPoint {
  final double x;
  final double y;
  final double z;

  VisionPoint._(Map<dynamic, dynamic> data)
      : x = data['x'],
        y = data['y'],
        z = data['z'] ?? null;
}

// android
//   https://firebase.google.com/docs/reference/android/com/google/firebase/ml/vision/face/FirebaseVisionFaceLandmark
class FaceLandmarkType {
  final int value;

  const FaceLandmarkType._(int value) : value = value;
  @deprecated
  static const BottomMouth = MouthBottom;
  static const MouthBottom = const FaceLandmarkType._(0);
  static const LeftCheek = const FaceLandmarkType._(1);
  static const LeftEar = const FaceLandmarkType._(3);
  static const LeftEye = const FaceLandmarkType._(4);
  @deprecated
  static const LeftMouth = MouthLeft;
  static const MouthLeft = const FaceLandmarkType._(5);
  static const NoseBase = const FaceLandmarkType._(6);
  static const RightCheek = const FaceLandmarkType._(7);
  static const RightEar = const FaceLandmarkType._(9);
  static const RightEye = const FaceLandmarkType._(10);
  @deprecated
  static const RightMouth = MouthRight;
  static const MouthRight = const FaceLandmarkType._(11);
}

class VisionFace {
  final Map<dynamic, dynamic> _data;

  final Rect rect;
  final int trackingID;
  final double headEulerAngleY;
  final double headEulerAngleZ;
  final double smilingProbability;
  final double rightEyeOpenProbability;
  final double leftEyeOpenProbability;
  final bool hasLeftEyeOpenProbability;
  final bool hasRightEyeOpenProbability;

  VisionFace._(this._data)
      : rect = Rect.fromLTRB(_data['rect_left'], _data['rect_top'], _data['rect_right'], _data['rect_bottom']),
        trackingID = _data['tracking_id'],
        headEulerAngleY = _data['head_euler_angle_y'],
        headEulerAngleZ = _data['head_euler_angle_z'],
        smilingProbability = _data['smiling_probability'],
        rightEyeOpenProbability = _data['right_eye_open_probability'],
        leftEyeOpenProbability = _data['left_eye_open_probability'],
        hasLeftEyeOpenProbability = _data['has_left_eye_open_probability'],
        hasRightEyeOpenProbability = _data['has_right_eye_open_probability'];

  VisionFaceLandmark getLandmark(FaceLandmarkType type) =>
      _data['landmarks'][type.value] == null ? null : VisionFaceLandmark._(_data['landmarks'][type.value]);
}

class FirebaseVisionFaceDetector {
  static const MethodChannel _channel = const MethodChannel('ml_kit_flutter/arenum');

  static FirebaseVisionFaceDetector instance = new FirebaseVisionFaceDetector._();

  FirebaseVisionFaceDetector._() {}

  Future<List<VisionFace>> detectFromBinary(Uint8List binary, [VisionFaceDetectorOptions option]) async {
    try {
      List<dynamic> faces = await _channel.invokeMethod("FirebaseVisionFaceDetector#detectFromBinary", {
        'binary': binary,
        'option': option?.asDictionary(),
      });
      List<VisionFace> ret = [];
      faces?.forEach((dynamic item) {
        print("item : $item");
        final VisionFace face = new VisionFace._(item);
        ret.add(face);
      });
      return ret;
    } catch (e) {
      print("Error on FirebaseVisionFaceDetector#detectFromBinary : ${e.toString()}");
    }
    return null;
  }

  Future<List<VisionFace>> detectFromPath(String filepath, [VisionFaceDetectorOptions option]) async {
    try {
      List<dynamic> faces = await _channel.invokeMethod("FirebaseVisionFaceDetector#detectFromPath", {
        'filepath': filepath,
        'option': option?.asDictionary(),
      });
      List<VisionFace> ret = [];
      faces?.forEach((dynamic item) {
        print("item : $item");
        final VisionFace face = new VisionFace._(item);
        ret.add(face);
      });
      return ret;
    } catch (e) {
      print("Error on FirebaseVisionFaceDetector#detectFromPath : ${e.toString()}");
    }
    return null;
  }
}
