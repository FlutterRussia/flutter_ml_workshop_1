import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class FirebaseModelInterpreter {
  static const MethodChannel _channel = const MethodChannel('ml_kit_flutter/arenum');

  static FirebaseModelInterpreter instance = new FirebaseModelInterpreter._();

  FirebaseModelInterpreter._() {}

  Future<List<dynamic>> run(
      {String remoteModelName,
      String localModelName,
      FirebaseModelInputOutputOptions inputOutputOptions,
      Uint8List inputBytes}) async {
    assert(remoteModelName != null || localModelName != null);
    try {
      dynamic results = await _channel.invokeMethod("FirebaseModelInterpreter#run", {
        'remoteModelName': remoteModelName,
        'localModelName': localModelName,
        'inputOutputOptions': inputOutputOptions.asDictionary(),
        'inputBytes': inputBytes
      });
      return results;
    } catch (e) {
      print("Error on FirebaseModelInterpreter#run : $e");
    }
    return null;
  }
}

class FirebaseModelIOOption {
  final FirebaseModelDataType dataType;
  final List<int> dims;

  const FirebaseModelIOOption(this.dataType, this.dims);
  Map<String, dynamic> asDictionary() {
    return {
      "dataType": dataType.value,
      "dims": dims,
    };
  }
}

//class FirebaseModelOptions {}

// android
//   https://firebase.google.com/docs/reference/android/com/google/firebase/ml/custom/FirebaseModelInputOutputOptions.Builder
class FirebaseModelInputOutputOptions {
  final List<FirebaseModelIOOption> inputOptions;
  final List<FirebaseModelIOOption> outputOptions;

  const FirebaseModelInputOutputOptions(this.inputOptions, this.outputOptions);

  Map<String, dynamic> asDictionary() {
    List<Map<String, dynamic>> inputs = [];
    List<Map<String, dynamic>> outputs = [];
    inputOptions.forEach((o) {
      inputs.add(o.asDictionary());
    });
    outputOptions.forEach((o) {
      outputs.add(o.asDictionary());
    });
    return {
      "inputOptions": inputs,
      "outputOptions": outputs,
    };
  }
}

// android
//   https://firebase.google.com/docs/reference/android/com/google/firebase/ml/custom/FirebaseModelDataType.DataType
class FirebaseModelDataType {
  final int value;
  const FirebaseModelDataType._(int value) : value = value;

  static const FLOAT32 = const FirebaseModelDataType._(1);
  static const INT32 = const FirebaseModelDataType._(2);
  static const BYTE = const FirebaseModelDataType._(3);
  static const LONG = const FirebaseModelDataType._(4);
}
