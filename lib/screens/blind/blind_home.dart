import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlindHome extends StatefulWidget {
  const BlindHome({Key? key}) : super(key: key);

  @override
  _BlindHomeState createState() => _BlindHomeState();
}

class _BlindHomeState extends State<BlindHome> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text("Hello there!!!, welcome to blind homepage"),
      ),
    );
  }
}
