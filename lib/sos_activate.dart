import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SOSActivate extends StatefulWidget {
  const SOSActivate({Key key}) : super(key: key);

  @override
  _SOSActivateState createState() => _SOSActivateState();
}

class _SOSActivateState extends State<SOSActivate> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: SizedBox.expand(
                child: FlatButton(
                    highlightColor: Color(0xff1c4257),
                    splashColor: Color(0xff253340),
                    onPressed: () => {Fluttertoast.showToast(msg: "SOS send succesfully", gravity: ToastGravity.TOP)},
                    child: Text("Send SOS",
                        style: TextStyle(
                            fontSize: 27.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold))))),
        color: Color(0xff1c4257),);
  }
}
