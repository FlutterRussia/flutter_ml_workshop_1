import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ml_worshop_1/sexy_ui/loading.dart';
import 'package:flutter_ml_worshop_1/utils/camera.dart';
import '../plugin/mlkit.dart';

class FaceDetectWidget extends StatefulWidget {
  @override
  _FaceDetectWidgetState createState() => new _FaceDetectWidgetState();
}

class _FaceDetectWidgetState extends State<FaceDetectWidget> {
  File _file;
  List<VisionFace> _currentLabels = <VisionFace>[];

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
          title: Text('face detect'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            tooltip: 'Back',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: _buildBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              var file = await CameraUtil.pickImage(context, true);
              setState(() {
                _file = file;
              });
              try {
                var currentLabels = await FirebaseVisionFaceDetector.instance.detectFromBinary(_file.readAsBytesSync());
                setState(() {
                  _currentLabels = currentLabels;
                });
              } catch (e) {
                print(e.toString());
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
      child: new Center(
        child: _file == null
            ? Text('No Image')
            : new FutureBuilder<Size>(
                future: _getImageSize(Image.file(_file, fit: BoxFit.fitWidth)),
                builder: (BuildContext context, AsyncSnapshot<Size> snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.data.width != null &&
                      snapshot.data.height != null) {
                    return Container(
                        foregroundDecoration: FaceDetectDecoration(_currentLabels, snapshot.data),
                        child: Image.file(_file, fit: BoxFit.fitWidth));
                  } else {
                    return LoadingBouncingGrid.square();
                  }
                },
              ),
      ),
    );
  }

  Future<Size> _getImageSize(Image image) {
    Completer<Size> completer = Completer<Size>();
    image.image.resolve(ImageConfiguration()).addListener(ImageStreamListener((ImageInfo info, bool _) =>
        completer.complete(Size(info.image.width.toDouble(), info.image.height.toDouble()))));
    return completer.future;
  }

  Widget _buildBody() {
    return Container(
      child: Column(
        children: <Widget>[
          _buildImage(),
        ],
      ),
    );
  }
}

class FaceDetectDecoration extends Decoration {
  final Size _originalImageSize;
  final List<VisionFace> _faces;
  FaceDetectDecoration(List<VisionFace> texts, Size originalImageSize)
      : _faces = texts,
        _originalImageSize = originalImageSize;

  @override
  BoxPainter createBoxPainter([VoidCallback onChanged]) {
    return new _FaceDetectPainter(_faces, _originalImageSize);
  }
}

class _FaceDetectPainter extends BoxPainter {
  final List<VisionFace> _faces;
  final Size _originalImageSize;
  _FaceDetectPainter(texts, originalImageSize)
      : _faces = texts,
        _originalImageSize = originalImageSize;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final paint = Paint()
      ..strokeWidth = 2.0
      ..color = Colors.red
      ..style = PaintingStyle.stroke;

    final _heightRatio = _originalImageSize.height / configuration.size.height;
    final _widthRatio = _originalImageSize.width / configuration.size.width;
    for (var text in _faces) {
      final _rect = Rect.fromLTRB(offset.dx + text.rect.left / _widthRatio, offset.dy + text.rect.top / _heightRatio,
          offset.dx + text.rect.right / _widthRatio, offset.dy + text.rect.bottom / _heightRatio);
      canvas.drawRect(_rect, paint);
    }
    canvas.restore();
  }
}
