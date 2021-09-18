import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorBlindHome extends StatefulWidget {
  const ColorBlindHome({Key? key}) : super(key: key);

  @override
  _ColorBlindHomeState createState() => _ColorBlindHomeState();
}

class _ColorBlindHomeState extends State<ColorBlindHome> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text("Hello there!!!, welcome to color blind homepage"),
      ),
    );
  }
}
