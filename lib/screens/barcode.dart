import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ml_worshop_1/sexy_ui/loading.dart';
import 'package:flutter_ml_worshop_1/utils/camera.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../plugin/mlkit.dart';

class BarcodeLabelImageWidget extends StatefulWidget {
  @override
  _BarcodeLabelImageWidgetState createState() => _BarcodeLabelImageWidgetState();
}

class _BarcodeLabelImageWidgetState extends State<BarcodeLabelImageWidget> {
  File _file;
  List<VisionBarcode> _currentLabels = <VisionBarcode>[];

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
          title: Text('label image'),
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
              if (file != null) {
                setState(() {
                  _file = file;
                });
                try {
                  var currentLabels = await FirebaseVisionBarcodeDetector.instance.detectFromPath(_file?.path);
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
      height: 350.0,
      child: Center(
        child: _file == null
            ? Text('No Image')
            : FutureBuilder<Size>(
                future: _getImageSize(Image.file(_file, fit: BoxFit.fitWidth)),
                builder: (BuildContext context, AsyncSnapshot<Size> snapshot) {
                  if (snapshot.hasData) {
                    return Container(child: Image.file(_file, fit: BoxFit.fitWidth));
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
    image.image.resolve(ImageConfiguration()).addListener(
          ImageStreamListener(
            (ImageInfo info, bool _) => completer.complete(
              Size(
                info.image.width.toDouble(),
                info.image.height.toDouble(),
              ),
            ),
          ),
        );
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

  Widget _buildList(List<VisionBarcode> labels) {
    if (labels.length == 0) {
      return Text('Empty');
    }
    return Expanded(
      child: Container(
        child: ListView.builder(
            padding: const EdgeInsets.all(1.0),
            itemCount: labels.length,
            itemBuilder: (context, i) {
              return _buildRow(labels[i]);
            }),
      ),
    );
  }

  Widget _buildRow(VisionBarcode vl) {
    return GestureDetector(
      onTap: () {
        if (vl.valueType == VisionBarcodeValueType.URL) {
          openTerms(vl.rawValue);
        } else {
          Clipboard.setData(ClipboardData(text: vl.rawValue));
          Toast.show("Data copied", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        }
      },
      child: ListTile(
        title: Text(
          ":${vl.valueType} : ${vl.rawValue}",
        ),
      ),
    );
  }

  void openTerms(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      }
    } catch (e) {
      print(e);
    }
  }
}
