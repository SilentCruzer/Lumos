import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeafHome extends StatefulWidget {
  const DeafHome({Key? key}) : super(key: key);

  @override
  _DeafHomeState createState() => _DeafHomeState();
}

class _DeafHomeState extends State<DeafHome> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text("Hello there!!!, welcome to deaf homepage"),
      ),
    );
  }
}
