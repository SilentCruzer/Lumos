import 'package:animated_splash/animated_splash.dart';
import 'package:divergent/screens/deaf/screens/landing_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeafHome extends StatefulWidget {
  const DeafHome({key}) : super(key: key);

  @override
  _DeafHomeState createState() => _DeafHomeState();
}

class _DeafHomeState extends State<DeafHome> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ASL Detection',
      theme: ThemeData(
        primaryColor: Color(0xff375079),
      ),
      home: LandingPage()
    );
  }
}
