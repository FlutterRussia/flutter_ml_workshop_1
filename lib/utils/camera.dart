import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class CameraUtil {
  static Future<File> pickImage(BuildContext context, bool camera) async {
    if (camera) {
      return await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      return await ImagePicker.pickImage(source: ImageSource.gallery);
    }
  }
}
