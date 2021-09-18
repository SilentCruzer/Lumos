import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'home.dart';

List<CameraDescription> cameras;

class BlindHome extends StatefulWidget {
  const BlindHome({key}) : super(key: key);

  @override
  _BlindHomeState createState() => _BlindHomeState();
}

class _BlindHomeState extends State<BlindHome> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Helping Hands',
        debugShowCheckedModeBanner: false,
        home: HomePage(cameras),
    );
  }
}
