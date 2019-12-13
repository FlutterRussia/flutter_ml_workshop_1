import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ml_worshop_1/sexy_ui/loading.dart';
import 'package:flutter_ml_worshop_1/utils/camera.dart';
import '../plugin/mlkit.dart';

class VisionTextWidget extends StatefulWidget {
  @override
  _VisionTextWidgetState createState() => _VisionTextWidgetState();
}

class _VisionTextWidgetState extends State<VisionTextWidget> {
  File _file;
  List<VisionText> _currentLabels = <VisionText>[];

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text('Text Detection'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            tooltip: 'Back',
            onPressed: () {
              /// Step 4
              /// Обрабатываем возвращение на предыдущий экран
              /// Напоминаю! Это можно реализовать с помощью [Navigator]
              Navigator.pop(context);
            },
          ),
        ),
        body: _buildBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            /// Step 6
            /// Реализуем логику:
            ///   1) делаем новое фото или берём из галереи при помощи [CameraUtil] в которой мы вызываем [ImagePicker].
            ///   2) Вызываем метод `detectFromPath` асинхронно (для этого существуют ключевые слова `async/await`)
            ///       у инстнса [FirebaseVisionTextDetector] который вернёт [List<VisionText>]. В классе [VisionText]
            ///       нам понадобится `text` и `rect`.
            ///   3) Вызываем метод `setState` который перересует данный Widget.
            try {
              var file = await CameraUtil.pickImage(context, true);
              if (file != null) {
                setState(() {
                  _file = file;
                });
                try {
                  var currentLabels = await FirebaseVisionTextDetector.instance.detectFromPath(_file?.path);
                  setState(() {
                    _currentLabels = currentLabels;
                  });
                } catch (e) {
                  print(e.toString());
                }
              }
            } catch (e) {
              print(e.toString());
            }
          },
          child: Icon(Icons.camera),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return SizedBox(
      height: 500.0,
      child: Center(
        /// Step 5
        /// Реализуем вывод изображение и наложение боксов с текстом
        /// Для этого используем FutureBuilder, у которого есть 2 параметра:
        ///   1) future - метод который принимает [Future] (https://api.dartlang.org/stable/2.7.0/dart-async/Future-class.html)
        ///       который возвращает в данном случе [Size] изображения
        ///   2) builder - метод который реализует виджет который будет отрисован в деревеотносительно данных которые придут
        ///       из future метода
        child: _file == null
            ? Text('No Image')
            : FutureBuilder<Size>(
                future: _getImageSize(Image.file(_file, fit: BoxFit.fitWidth)),
                builder: (BuildContext context, AsyncSnapshot<Size> snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                        foregroundDecoration: TextDetectDecoration(_currentLabels, snapshot.data),
                        child: Image.file(_file, fit: BoxFit.fitWidth));
                  } else {
                    return LoadingBouncingGrid.square(
                      backgroundColor: Colors.indigo,
                    );
                  }
                },
              ),
      ),
    );
  }

  Future<Size> _getImageSize(Image image) {
    Completer<Size> completer = Completer<Size>();
    image.image.resolve(ImageConfiguration()).addListener(ImageStreamListener((ImageInfo info, bool _) {
      return completer.complete(Size(info.image.width.toDouble(), info.image.height.toDouble()));
    }));
    return completer.future;
  }

  Widget _buildBody() {
    return Container(
      child: Column(
        children: <Widget>[
          _buildImage(),
          _buildList(_currentLabels),
        ],
      ),
    );
  }

  Widget _buildList(List<VisionText> texts) {
    if (texts.length == 0) {
      return Text('Empty');
    }
    return Expanded(
      child: Container(
        child: ListView.builder(
            padding: const EdgeInsets.all(1.0),
            itemCount: texts.length,
            itemBuilder: (context, i) {
              return _buildRow(texts[i].text);
            }),
      ),
    );
  }

  Widget _buildRow(String text) {
    return ListTile(
      title: Text(
        "Text: $text",
      ),
      dense: true,
    );
  }
}

class TextDetectDecoration extends Decoration {
  final Size _originalImageSize;
  final List<VisionText> _texts;
  TextDetectDecoration(List<VisionText> texts, Size originalImageSize)
      : _texts = texts,
        _originalImageSize = originalImageSize;

  @override
  BoxPainter createBoxPainter([VoidCallback onChanged]) {
    return _TextDetectPainter(_texts, _originalImageSize);
  }
}

class _TextDetectPainter extends BoxPainter {
  final List<VisionText> _texts;
  final Size _originalImageSize;
  _TextDetectPainter(texts, originalImageSize)
      : _texts = texts,
        _originalImageSize = originalImageSize;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    /// Step 7
    /// Рисуем боксы у распозного текста.
    /// У канваса есть метод `drawRect` для отрисовки прямоугольноков(боксов) котрые распознал наш ML
    /// Для того чтобы нарисовать прямоугольник, нужно 2 вещи:
    ///   1) [Paint] у которого мы можем задать `color`, `style`, `strokeWidth` и тд.
    ///   2) [Rect] сам прямоугольник
    ///
    /// Так как у нас [List<VisionText>] нам нужно профтись по всем объектам списка и отрисаовать для каждого из них
    /// совй бокс.
    ///
    /// Советую использовать [Rect.fromLTRB]. Для простоты даю формулу по которой будет составлятся прямоугольник
    /// ```
    /// Rect.fromLTRB(offset.dx + text.rect.left / _widthRatio, offset.dy + text.rect.top / _heightRatio,
    ///   offset.dx + text.rect.right / _widthRatio, offset.dy + text.rect.bottom / _heightRatio)
    /// ```
    ///
    /// В самом конце нам нужно обновить весь канвас при помощи метода `restore`
    final paint = Paint()
      ..strokeWidth = 2.0
      ..color = Colors.red
      ..style = PaintingStyle.stroke;

    final _heightRatio = _originalImageSize.height / configuration.size.height;
    final _widthRatio = _originalImageSize.width / configuration.size.width;
    for (var text in _texts) {
      final _rect = Rect.fromLTRB(offset.dx + text.rect.left / _widthRatio, offset.dy + text.rect.top / _heightRatio,
          offset.dx + text.rect.right / _widthRatio, offset.dy + text.rect.bottom / _heightRatio);
      canvas.drawRect(_rect, paint);
    }

    canvas.restore();
  }
}
