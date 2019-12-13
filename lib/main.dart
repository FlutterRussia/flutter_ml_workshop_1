import 'package:flutter/material.dart';
import 'package:flutter_ml_worshop_1/screens/barcode.dart';
import 'package:flutter_ml_worshop_1/sexy_ui/card.dart';

import 'screens/custom-models.dart';
import 'screens/vision-text.dart';
import 'screens/face-detect.dart';
import 'screens/label-image.dart';

List<CardModel> list = [
  CardModel(
    title: 'Распознавание текста',
    subtitle: 'Распознавание и извлечение текста на изображениях.',
    url: 'https://www.gstatic.com/mobilesdk/180427_mobilesdk/mlkit/text_recognition@2x.png',
    routeName: 'vision-text',
  ),
  CardModel(
    title: 'Распознавание лиц',
    subtitle: 'Распознавание лиц, лицевых опорных точек и контуров лиц',
    url: 'https://www.gstatic.com/mobilesdk/181112_mobilesdk/face_detection_with_contour@2x.png',
    routeName: 'face-detect',
  ),
  CardModel(
    title: 'Сканирование штрихкодов',
    subtitle: 'Сканирование и обработка штрихкодов',
    url: 'https://www.gstatic.com/mobilesdk/180427_mobilesdk/mlkit/barcode_scanning@2x.png',
    routeName: 'barcode',
  ),
  CardModel(
    title: 'Распознование объектов',
    subtitle: 'Распознование и обработка объектов',
    url: 'https://www.gstatic.com/mobilesdk/190415_mobilesdk/object_detection@2x.png',
    routeName: 'label-image',
  ),
  CardModel(
    title: 'Custom model',
    subtitle: 'Custom model',
    url: 'https://www.gstatic.com/mobilesdk/190415_mobilesdk/automl@2x.png',
    routeName: 'custom-model',
  ),
];

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      /// Step 1
      /// Переходы в приложении осуществляются при помощи [Navigator]. Тут нужно проинициализировать 
      /// все пути в приложении для того чтобы мы могли переходить на заданные страницы в приложении
    },
  ));
}

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MLKit Workshop'),
      ),
      body: Container(),
      /// Step 3
      /// В место [Container] мы должы реализовать список [CustomCard]
    );
  }
}

class CardModel {
  CardModel({
    this.title,
    this.subtitle,
    this.url,
    this.routeName,
  });

  final String title;
  final String subtitle;
  final String url;
  final String routeName;
}
