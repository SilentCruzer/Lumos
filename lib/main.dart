import 'package:divergent/screens/blind/blind_home.dart';
import 'package:divergent/screens/color_blind/color_blind_home.dart';
import 'package:divergent/screens/deaf/deaf_home.dart';
import 'package:flutter/material.dart';

void main() {
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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BlindHome()),
                );
      },
              child: Container(
                height: 250,
                width: double.infinity,
                child: Card(
                  child: Center(child: Text("Blind",
                  style: TextStyle(
                    fontSize: 30
                  ),)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeafHome()),
                );
              },
              child: Container(
                height: 250,
                width: double.infinity,
                child: Card(
                  child: Center(child: Text("Deaf",
                    style: TextStyle(
                        fontSize: 30
                    ),)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ColorBlindHome()),
                );
              },
              child: Container(
                height: 250,
                width: double.infinity,
                child: Card(
                  child: Center(child: Text("Color Blind",
                    style: TextStyle(
                        fontSize: 30
                    ),)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
