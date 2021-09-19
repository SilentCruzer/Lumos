import 'package:divergent/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:divergent/screens/deaf/screens/detectScreen.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(
          'Introduction',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25)),
              color: Color(0xff375079)
          ),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            child: Padding(
          padding: const EdgeInsets.only(top: 150.0, left: 35),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Hello and welcome to",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 25,
                    fontFamily: "Roboto",
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "ASL Detection.",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Color(0xff375079),
                    fontSize: 25,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "This app lets you to\ndetect letters by using\nImage Detection.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 25,
                    fontFamily: "Roboto",
                  ),
                ),
              ),
              SizedBox(
                height: (MediaQuery.of(context).size.height * 0.20),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.add_a_photo,
                      color: Color(0xff3ACCE1),
                      size: 30,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Use our image analyser to detect\nthe letters.",
                        style: TextStyle(
                            color: Color(0xff41A1FF),
                            fontSize: 15,
                            fontFamily: "Roboto"),
                      ),
                    ),
                  ]),
              SizedBox(height: 15),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.volume_up,
                      color: Color(0xff3ACCE1),
                      size: 30,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Converts texts to speech\nwith a tap.",
                        style: TextStyle(
                            color: Color(0xff41A1FF),
                            fontSize: 15,
                            fontFamily: "Roboto"),
                      ),
                    ),
                  ]),
              SizedBox(height: MediaQuery.of(context).size.height * 0.10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "ASL Detection",
                      style: TextStyle(
                        color: Color(0xff375079),
                        fontFamily: "Roboto",
                        fontSize: 23,
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.37),
                  //IconButton(icon: Icon(Icons.arrow_forward, size: 35,), onPressed: () {})
                ],
              )
            ],
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff375079),
        child: IconButton(
            icon: Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: null),
        onPressed: () {
          Navigator.of(context).pushReplacement(
              new MaterialPageRoute(builder: (BuildContext context) {
            return DetectScreen(title: 'ASL Detection');
          }));
        },
      ),
    );
  }
}
