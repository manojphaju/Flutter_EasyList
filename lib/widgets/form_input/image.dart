import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File _image;
  final picker = ImagePicker();

  void _getImage(BuildContext context, ImageSource source) async {
    final pickedFile = await picker.getImage(source: source, maxWidth: 400.0);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        Navigator.pop(context);
      }
    });
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 150.0,
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    'Pick an Image',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  TextButton(
                    onPressed: () {
                      _getImage(context, ImageSource.camera);
                    },
                    child: Text('Use Camera'),
                  ),
                  TextButton(
                    onPressed: () {
                      _getImage(context, ImageSource.gallery);
                    },
                    child: Text('Use Gallery'),
                  ),
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          onPressed: () {
            _openImagePicker(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt),
              SizedBox(
                width: 5.0,
              ),
              Text(
                'Add Image',
              )
            ],
          ),
        ),
        SizedBox(height: 10.0),
        _image == null
            ? Text('Please pick an image')
            : Image.file(_image,
                fit: BoxFit.cover,
                height: 300.0,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.topCenter),
      ],
    );
  }
}
