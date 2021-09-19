import 'package:divergent/screens/blind/blind_home.dart';
import 'package:divergent/screens/blind/sos/sos_dialog.dart';
import 'package:divergent/screens/color_blind/color_blind_home.dart';
import 'package:divergent/screens/deaf/deaf_home.dart';
import 'package:divergent/sos_activate.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shake/shake.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:tflite/tflite.dart';
import 'package:telephony/telephony.dart';

sosDialog sd = new sosDialog();
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
      home: MySplash(),
    );
  }
}


class MySplash extends StatefulWidget {
  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: MyHomePage(),
      gradientBackground: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.4,0.7],
        colors: [
          Color(0xff1c4257),
          Color(0xff253340),
        ],
      ),
      photoSize: 50,
      useLoader: true,
      loaderColor: Colors.white70,
      image: Image.asset('assets/icon-circle.png'),
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SOSActivate()),
      );
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
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.grey[300],
        elevation: 0,
        title: Text(
          'Select an option',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25)),
              color: Color(0xff375079)
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                sd.sosDialogBox(context);
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
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
                          backgroundColor: Colors.grey[200],
                      )
                    ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: new Container(
                      child: new Text('Blind',
                          style: TextStyle(
                            color: Color(0xff375079),
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
                                    backgroundColor: Colors.grey[200],
                                  )
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: new Container(
                                  child: new Text('Deaf/\nMute',
                                    style: TextStyle(
                                        color: Color(0xff375079),
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
                                    backgroundColor: Colors.grey[200],
                                  )
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: new Container(
                                  child: new Text('Colour\nBlind',
                                    style: TextStyle(
                                        color: Color(0xff375079),
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
      ),
    );
  }
}
