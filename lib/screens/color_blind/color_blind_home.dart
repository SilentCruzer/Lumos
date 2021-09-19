
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
    if(_image!=null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ImageColor(path: _image.path)));
    }
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
        leading:
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {Navigator.of(context).pop();},
          ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only( left: 15.0, right: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () => getImage(ImgSource.Gallery),
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 8,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child:Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: new Container(
                                    child: new Text('From Gallery',
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
                SizedBox(height: 20,),
                InkWell(
                  onTap: () => getImage(ImgSource.Camera),
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 8,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child:Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: new Container(
                                    child: new Text('From Camera',
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
      ),
    );
  }
}
