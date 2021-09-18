
library image_picker_gallery_camera;

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerGC {
  static Future pickImage(
      { BuildContext context,
        ImgSource source,
        bool enableCloseButton,
        double maxWidth,
        double maxHeight,
        Icon cameraIcon,
        Icon galleryIcon,
        Widget cameraText,
        Widget galleryText,
        bool barrierDismissible = false,
        Icon closeIcon,
        int imageQuality}) async {
    assert(imageQuality == null || (imageQuality >= 0 && imageQuality <= 100));

    if (maxWidth != null && maxWidth < 0) {
      throw ArgumentError.value(maxWidth, 'maxWidth cannot be negative');
    }

    if (maxHeight != null && maxHeight < 0) {
      throw ArgumentError.value(maxHeight, 'maxHeight cannot be negative');
    }

    switch (source) {
      case ImgSource.Camera:
        return await ImagePicker().getImage(
            source: ImageSource.camera,
            maxWidth: maxWidth,
            maxHeight: maxHeight);
      case ImgSource.Gallery:
        return await ImagePicker().getImage(
            source: ImageSource.gallery,
            maxWidth: maxWidth,
            maxHeight: maxHeight);
      case ImgSource.Both:
        return await showDialog<void>(
          context: context,
          barrierDismissible: barrierDismissible, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  enableCloseButton == true
                      ? GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Align(
                        alignment: Alignment.topRight,
                        child: closeIcon ??
                            Icon(
                              Icons.close,
                              size: 14,
                            )),
                  )
                      : Container(),
                  InkWell(
                    onTap: () async {
                      ImagePicker()
                          .getImage(
                          source: ImageSource.gallery,
                          maxWidth: maxWidth,
                          maxHeight: maxHeight,
                          imageQuality: imageQuality)
                          .then((image) {
                        Navigator.pop(context, image);
                      });
                    },
                    child: Container(
                      child: ListTile(
                          title: galleryText ?? Text("Gallery"),
                          leading: galleryIcon != null
                              ? galleryIcon
                              : Icon(
                            Icons.image,
                            color: Colors.deepPurple,
                          )),
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 1,
                    color: Colors.black12,
                  ),
                  InkWell(
                    onTap: () async {
                      ImagePicker()
                          .getImage(
                          source: ImageSource.camera,
                          maxWidth: maxWidth,
                          maxHeight: maxHeight)
                          .then((image) {
                        Navigator.pop(context, image);
                      });
                    },
                    child: Container(
                      child: ListTile(
                          title: cameraText ?? Text("Camera"),
                          leading: cameraIcon != null
                              ? cameraIcon
                              : Icon(
                            Icons.camera,
                            color: Colors.deepPurple,
                          )),
                    ),
                  ),
                ],
              ),
            );
          },
        );
    }
  }
}

enum ImgSource { Camera, Gallery, Both }