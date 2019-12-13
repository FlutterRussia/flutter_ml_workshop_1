import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

// android
//   https://firebase.google.com/docs/reference/android/com/google/firebase/ml/custom/FirebaseModelManager
// If you specify both a local and remote model,
// ML Kit will use the remote model if it is available,
// and fall back to the locally-stored model if the remote model isn't available.
class FirebaseModelManager {
  //final FirebaseLocalModelSource localModelSource;
  //final FirebaseRemoteModelSource RemoteModelSource;
  static const MethodChannel _channel = const MethodChannel('ml_kit_flutter/arenum');

  static FirebaseModelManager instance = FirebaseModelManager._();

  FirebaseModelManager._();

  Future<void> registerRemoteModelSource(FirebaseRemoteModelSource cloudSource) async {
    try {
      await _channel
          .invokeMethod("FirebaseModelManager#registerRemoteModelSource", {'source': cloudSource.asDictionary()});
    } catch (e) {
      print("Error on FirebaseModelManager#registerRemoteModelSource : ${e.toString()}");
    }
    return null;
  }

  Future<void> registerLocalModelSource(FirebaseLocalModelSource localSource) async {
    try {
      await _channel
          .invokeMethod("FirebaseModelManager#registerLocalModelSource", {'source': localSource.asDictionary()});
    } catch (e) {
      print("Error on FirebaseModelManager#registerLocalModelSource : ${e.toString()}");
    }
    return null;
  }
}

// android
//   https://firebase.google.com/docs/reference/android/com/google/firebase/ml/custom/model/FirebaseLocalModelSource
// Sets a local model name to FirebaseModelOptions.
// Note local model has a lower priority than the cloud model, if specified.
// It will only be used if there is no FirebaseRemoteModel or the download of FirebaseRemoteModel fails.
// via https://firebase.google.com/docs/reference/android/com/google/firebase/ml/custom/FirebaseModelOptions.Builder.html
class FirebaseLocalModelSource {
  final String modelName;
  final String assetFilePath;

  FirebaseLocalModelSource({
    @required this.modelName,
    @required this.assetFilePath,
  });

  Map<String, dynamic> asDictionary() {
    return {"modelName": modelName, "assetFilePath": assetFilePath};
  }
}

// android
//   https://firebase.google.com/docs/reference/android/com/google/firebase/ml/custom/model/FirebaseRemoteModelSource
class FirebaseRemoteModelSource {
  final String modelName;
  final bool enableModelUpdates;
  final FirebaseModelDownloadConditions initialDownloadConditions;
  final FirebaseModelDownloadConditions updatesDownloadConditions;

  static const _defaultCondition = FirebaseModelDownloadConditions();

  FirebaseRemoteModelSource(
      {@required this.modelName,
      this.enableModelUpdates: false,
      this.initialDownloadConditions: _defaultCondition,
      this.updatesDownloadConditions: _defaultCondition});

  Map<String, dynamic> asDictionary() {
    return {
      "modelName": modelName,
      "enableModelUpdates": enableModelUpdates,
      "initialDownloadConditions": initialDownloadConditions.asDictionary(),
      "updatesDownloadConditions": updatesDownloadConditions.asDictionary(),
    };
  }
}

// android
//   https://firebase.google.com/docs/reference/android/com/google/firebase/ml/custom/model/FirebaseModelDownloadConditions
class FirebaseModelDownloadConditions {
  final bool requireWifi;
  final bool requireDeviceIdle;
  final bool requireCharging;

  const FirebaseModelDownloadConditions(
      {this.requireCharging: false, this.requireDeviceIdle: false, this.requireWifi: false});

  Map<String, dynamic> asDictionary() {
    return {"requireWifi": requireWifi, "requireDeviceIdle": requireDeviceIdle, "requireCharging": requireCharging};
  }
}
