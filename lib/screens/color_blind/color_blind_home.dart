
import 'dart:io';
import 'package:divergent/screens/color_blind/screens/capture_display.dart';
import 'package:divergent/screens/color_blind/screens/image_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorBlindHome extends StatefulWidget {
  const ColorBlindHome({key}) : super(key: key);

  @override
  _ColorBlindHomeState createState() => _ColorBlindHomeState();
}

class _ColorBlindHomeState extends State<ColorBlindHome> {
  var _image;
  Future getImage(ImgSource source) async {
    var image = await ImagePickerGC.pickImage(
        enableCloseButton: true,
        closeIcon: Icon(
          Icons.close,
          color: Colors.red,
          size: 12,
        ),
        context: context,
        source: source,
        barrierDismissible: true,
        cameraIcon: Icon(
          Icons.camera_alt,
          color: Colors.red,
        ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
        cameraText: Text(
          "From Camera",
          style: TextStyle(color: Colors.red),
        ),
        galleryText: Text(
          "From Gallery",
          style: TextStyle(color: Colors.blue),
        ));
    setState(() {
      _image = image;
    });
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ImageColor(path: _image.path)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => getImage(ImgSource.Gallery),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.black)
                          )
                      )
                  ),
                  child: Text(
                    "From Gallery".toUpperCase(),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => getImage(ImgSource.Camera),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.black)
                          )
                      )
                  ),
                  child: Text(
                    "From Camera".toUpperCase(),
                    style: TextStyle(color: Colors.black),
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
