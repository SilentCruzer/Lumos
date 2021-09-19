import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:colornames/colornames.dart';
import 'package:divergent/screens/color_blind/screens/indicator.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class ImageColor extends StatefulWidget {
  final String path;
  const ImageColor({Key key, this.path});

  @override
  _ImageColorState createState() => _ImageColorState();
}

class _ImageColorState extends State<ImageColor> {
  GlobalKey imageKey = GlobalKey();
  GlobalKey paintKey = GlobalKey();

  // CHANGE THIS FLAG TO TEST BASIC IMAGE, AND SNAPSHOT.
  bool useSnapshot = true;

  // based on useSnapshot=true ? paintKey : imageKey ;
  // this key is used in this example to keep the code shorter.
  GlobalKey currentKey;

  final StreamController<Color> _stateController = StreamController<Color>();
  img.Image photo;
  Offset position = Offset(10, 10);

  @override
  void initState() {
    currentKey = useSnapshot ? paintKey : imageKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: IconButton(onPressed: () => {Navigator.pop(context)}, icon: Icon(Icons.arrow_back),
          color: Colors.white,),
          title: Text("Image Color Picker", style: TextStyle(
            fontSize: 18,
      color: Colors.white,

      ),),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25)),
              color: Color(0xff375079)
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: StreamBuilder(
          initialData: Colors.green[500],
          stream: _stateController.stream,
          builder: (buildContext, snapshot) {
            Color selectedColor = snapshot.data ?? Colors.green;
            return Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Stack(
                children: <Widget>[
                  RepaintBoundary(
                    key: paintKey,
                    child: GestureDetector(
                      onPanDown: (details) {
                        setState(() {
                          position = details.globalPosition;
                        });
                        searchPixel(details.globalPosition);
                      },
                      onPanUpdate: (details) {
                        setState(() {
                          position = details.globalPosition;
                        });
                        searchPixel(details.globalPosition);
                      },
                      child: Container(
                        height: 500,
                        width: double.infinity,
                        child: Card(
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              )
                          ),
                          child: Image.file(
                            File(widget.path),
                            key: imageKey,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: position,
                    child: Positioned(
                      top: position.dy - (25 / 2),
                      left: position.dx - (25 / 2),
                      child: ColorIndicator(),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 130,
                        width: double.infinity,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              topLeft: Radius.circular(30),
                            )
                          ),
                          elevation: 1,
                          color: Colors.black26,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Text("Color Info", style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15
                                ),),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: selectedColor,
                                          border: Border.all(width: 2.0, color: Colors.white),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 4,
                                                offset: Offset(0, 2))
                                          ]),
                                    ),
                                    Text('${ColorNames.guess(selectedColor)}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],

              ),
            );
          }),
    );
  }

  void searchPixel(Offset globalPosition) async {
    if (photo == null) {
      await (useSnapshot ? loadSnapshotBytes() : loadImageBundleBytes());
    }
    _calculatePixel(globalPosition);
  }

  void _calculatePixel(Offset globalPosition) {
    RenderBox box = currentKey.currentContext.findRenderObject();
    Offset localPosition = box.globalToLocal(globalPosition);

    double px = localPosition.dx;
    double py = localPosition.dy;

    if (!useSnapshot) {
      double widgetScale = box.size.width / photo.width;
      print(py);
      px = (px / widgetScale);
      py = (py / widgetScale);
    }

    int pixel32 = photo.getPixelSafe(px.toInt(), py.toInt());
    int hex = abgrToArgb(pixel32);

    _stateController.add(Color(hex));
  }

  Future<void> loadImageBundleBytes() async {
    ByteData imageBytes = await rootBundle.load(widget.path);
    setImageBytes(imageBytes);
  }

  Future<void> loadSnapshotBytes() async {
    RenderRepaintBoundary boxPaint = paintKey.currentContext.findRenderObject();
    ui.Image capture = await boxPaint.toImage();
    ByteData imageBytes =
    await capture.toByteData(format: ui.ImageByteFormat.png);
    setImageBytes(imageBytes);
    capture.dispose();
  }

  void setImageBytes(ByteData imageBytes) {
    List<int> values = imageBytes.buffer.asUint8List();
    photo = null;
    photo = img.decodeImage(values);
  }
}

// image lib uses uses KML color format, convert #AABBGGRR to regular #AARRGGBB
int abgrToArgb(int argbColor) {
  int r = (argbColor >> 16) & 0xFF;
  int b = argbColor & 0xFF;
  return (argbColor & 0xFF00FF00) | (b << 16) | r;
}
