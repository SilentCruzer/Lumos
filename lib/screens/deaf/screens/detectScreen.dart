import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:divergent/screens/deaf/helpers/app_helper.dart';
import 'package:divergent/screens/deaf/helpers/camera_helper.dart';
import 'package:divergent/screens/deaf/helpers/tflite_helper.dart';
import 'package:divergent/screens/deaf/models/result.dart';
import 'package:flutter_tts/flutter_tts.dart';

class DetectScreen extends StatefulWidget {
  DetectScreen({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _DetectScreenState createState() => _DetectScreenState();
}

class _DetectScreenState extends State<DetectScreen>
    with TickerProviderStateMixin {
  AnimationController _colorAnimController;
  Animation _colorTween;
  final FlutterTts flutterTts = FlutterTts();

  List<Result> outputs;
  String prev_detection = '';
  var prev_time=DateTime.now().millisecondsSinceEpoch;

  void initState() {
    super.initState();

    //Load TFLite Model
    TFLiteHelper.loadModel().then((value) {
      setState(() {
        TFLiteHelper.modelLoaded = true;
      });
    });

    //Initialize Camera
    CameraHelper.initializeCamera();

    //Setup Animation
    _setupAnimation();

    //Subscribe to TFLite's Classify events
    TFLiteHelper.tfLiteResultsController.stream.listen(
        (value) {
          value.forEach((element) {
            _colorAnimController.animateTo(element.confidence,
                curve: Curves.bounceIn, duration: Duration(milliseconds: 500));
          });

          //Set Results
          outputs = value;

          //Update results on screen
          setState(() {
            //Set bit to false to allow detection again
            CameraHelper.isDetecting = false;
          });
        },
        onDone: () {},
        onError: (error) {
          AppHelper.log("listen", error);
        });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.grey[100],
        elevation: 3,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.grey[600],
            ),
          ),
        title:  Text(widget.title,
        style: TextStyle(color: Colors.grey[600],
      ))),
      body: FutureBuilder<void>(
        future: CameraHelper.initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Stack(
              children: <Widget>[
                CameraPreview(CameraHelper.camera),
                _buildResultsWidget(width, outputs)
              ],
            );
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    TFLiteHelper.disposeModel();
    CameraHelper.camera.dispose();
    AppHelper.log("dispose", "Clear resources.");
    super.dispose();
  }

  Widget _buildResultsWidget(double width, List<Result> outputs) {
    Future speak(String s) async {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(1);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak(s);
    }

    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 200.0,
          width: width,
          color: Colors.white,
          child: outputs != null && outputs.isNotEmpty
              ? ListView.builder(
                  itemCount: outputs.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(20.0),
                  itemBuilder: (BuildContext context, int index) {
                    String current_detection=outputs[index].label.substring(2);
                    var current_time=DateTime.now().millisecondsSinceEpoch;
                    if(current_detection != prev_detection && (current_time-prev_time>1000)) {
                      speak("$current_detection");
                      prev_detection=current_detection;
                      prev_time=current_time;
                    }
                    return Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                         'Letter Detected:',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 20.0,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          current_detection,
                          style: TextStyle(
                            color: _colorTween.value,
                            fontSize: 70.0,
                          ),
                        ),
                      ],
                    );
                  })
              : Center(
                  child: Text("Wating for model to detect..",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                      ))),

        ),
      ),
    );
  }

  void _setupAnimation() {
    _colorAnimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _colorTween = ColorTween(begin: Colors.green, end: Colors.red)
        .animate(_colorAnimController);
  }
}
