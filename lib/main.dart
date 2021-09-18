import 'package:divergent/screens/blind/blind_home.dart';
import 'package:divergent/screens/blind/sos/sos_dialog.dart';
import 'package:divergent/screens/color_blind/color_blind_home.dart';
import 'package:divergent/screens/deaf/deaf_home.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shake/shake.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite/tflite.dart';
import 'package:telephony/telephony.dart';

final Telephony telephony = Telephony.instance;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({key}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var sosCount = 0;
  var initTime;

  @override
  Future<void> initState() {
    super.initState();
    smsPermission();
    loadModel();
    ShakeDetector detector = ShakeDetector.waitForStart(onPhoneShake: () {
      if (sosCount == 0) {
        initTime = DateTime.now();
        ++sosCount;
      } else {
        if (DateTime.now().difference(initTime).inSeconds < 4) {
          ++sosCount;
          if (sosCount == 6) {
            sendSms();
            sosCount = 0;
          }
          print(sosCount);
        } else {
          sosCount = 0;
          print(sosCount);
        }
      }
    });

    detector.startListening();
  }

  void sendSms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String n1 = prefs.getString('n1');
    String n2 = prefs.getString('n2');
    String n3 = prefs.getString('n3');
    String name = prefs.getString('name');
    Position position =
    await getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    if (position == null) {
      position = await getLastKnownPosition();
    }
    String lat = (position.latitude).toString();
    String long = (position.longitude).toString();
    String alt = (position.altitude).toString();
    String speed = (position.speed).toString();
    String timestamp = (position.timestamp).toIso8601String();
    print(n2);
    telephony.sendSms(
        to: n1,
        message:
        "$name needs you help, last seen at: Latitude: $lat, Longitude: $long, Altitude: $alt, Speed: $speed, Time: $timestamp");
    telephony.sendSms(
        to: n2,
        message:
        "$name needs you help, last seen at:  Latitude: $lat, Longitude: $long, Altitude: $alt, Speed: $speed, Time: $timestamp");
    telephony.sendSms(
        to: n3,
        message:
        "$name needs you help, last seen at:  Latitude: $lat, Longitude: $long, Altitude: $alt, Speed: $speed, Time: $timestamp");
  }

  void smsPermission() async {
    //bool permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
  }

  loadModel() async {
    String res = await Tflite.loadModel(
        model: "assets/ssd_mobilenet.tflite",
        labels: "assets/ssd_mobilenet.txt");
    print("MODEL" + res);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BlindHome()),
                  );
      },
                child: Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 8,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                          children: <Widget>[
                      new Container(
                      child:
                      new CircleAvatar(
                      backgroundImage: new AssetImage('assets/images/blind_image.png'),
                      radius: 80.0,
                        backgroundColor: Colors.grey[50],
                    )
                  ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: new Container(
                    child: new Text('Blind',
                        style: TextStyle(
                          color: Colors.grey[600],
                        fontSize: 30
                    ),
                    ),
                  ),
                )
                ],
              )
                      ),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DeafHome()),
                  );
                },
                child: Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 8,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            new Container(
                                child:
                                new CircleAvatar(
                                  backgroundImage: new AssetImage('assets/images/deaf_image.png'),
                                  radius: 80.0,
                                  backgroundColor: Colors.grey[50],
                                )
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: new Container(
                                child: new Text('Deaf/\nMute',
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 30
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ColorBlindHome()),
                  );
                },
                child: Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 8,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            new Container(
                                child:
                                new CircleAvatar(
                                  backgroundImage: new AssetImage('assets/images/colour_blind_image.png'),
                                  radius: 80.0,
                                  backgroundColor: Colors.grey[50],
                                )
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: new Container(
                                child: new Text('Colour\nBlind',
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 30
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
