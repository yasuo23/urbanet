// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class MyImagePicker extends StatefulWidget {
//   MyImagePicker();

//   @override
//   MyImagePickerState createState() => MyImagePickerState();
// }

// class MyImagePickerState extends State<MyImagePicker> {
//   File? _imageFile;
//   File? getimage() {
//     return _imageFile;
//   }

//   Future<void> _pickImage() async {
//     final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }

//   void _clearImage() {
//     setState(() {
//       _imageFile = null;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//         child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Stack(
//           alignment: Alignment.topRight,
//           children: [
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 primary: Color.fromARGB(255, 65, 41, 151),
//               ),
//               onPressed: _pickImage,
//               child: _imageFile == null
//                   ? Ink.image(
//                       image: AssetImage('images/image.png'),
//                       width: 110.0,
//                       height: 110.0,
//                     )
//                   : Ink.image(
//                       image: FileImage(_imageFile!),
//                       fit: BoxFit.cover,
//                       width: 150.0,
//                       height: 110.0,
//                       child: Positioned(
//                         top: 16.0,
//                         right: 16.0,
//                         child: IconButton(
//                           onPressed: _clearImage,
//                           icon: Icon(Icons.close_rounded),
//                           color: Colors.redAccent,
//                         ),
//                       ),
//                     ),
//             ),
//           ],
//         ),
//       ],
//     ));
//   }
// }
//
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class MyImagePicker extends StatefulWidget {
  MyImagePicker();

  @override
  MyImagePickerState createState() => MyImagePickerState();
}

class MyImagePickerState extends State<MyImagePicker> {
  File? _imageFile;
  File? getimage() {
    return _imageFile;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _checkImageResolution();
      });
    }
  }

  void _clearImage() {
    setState(() {
      _imageFile = null;
    });
  }

  Future<void> _checkImageResolution() async {
    final imageBytes = await _imageFile!.readAsBytes();
    final decodedImage = img.decodeImage(imageBytes);
    if (decodedImage != null) {
      final width = decodedImage.width;
      final height = decodedImage.height;
      final resolutionX = (width / _getImageInches(width)).round();
      final resolutionY = (height / _getImageInches(height)).round();
      print('Image resolution: $resolutionX DPI (X), $resolutionY DPI (Y)');
      if (resolutionX <= 200 || resolutionY <= 200) {
        print('Image resolution is not greater than 200 DPI');
      }
    }
  }

  double _getImageInches(int pixels) {
    // Assuming 72 pixels per inch (standard DPI for screens)
    return pixels / 72.0;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 65, 41, 151),
                ),
                onPressed: _pickImage,
                child: _imageFile == null
                    ? Ink.image(
                        image: AssetImage('images/image.png'),
                        width: 110.0,
                        height: 110.0,
                      )
                    : Ink.image(
                        image: FileImage(_imageFile!),
                        fit: BoxFit.cover,
                        width: 150.0,
                        height: 110.0,
                        child: Positioned(
                          top: 16.0,
                          right: 16.0,
                          child: IconButton(
                            onPressed: _clearImage,
                            icon: Icon(Icons.close_rounded),
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
