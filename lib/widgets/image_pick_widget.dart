import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ImagePick extends StatefulWidget {
  @override
  _ImagePickState createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePick> {
  String? imageUrl;
  void uploadImage() async {
    if (kIsWeb) {
      html.FileUploadInputElement uploadInput = html.FileUploadInputElement()
        ..accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((event) {
        final file = uploadInput.files!.first;
        final fileName = uploadInput.files!.single.name;
        final reader = html.FileReader();
        reader.readAsDataUrl(file);
        reader.onLoad.listen((event) async {
          var task = await FirebaseStorage.instance
              .ref('uploads/$fileName')
              .putBlob(file);
          String url = await task.ref.getDownloadURL();
          print('url is $url');
          setState(() {
            imageUrl = url;
          });
        });
      });
    } else {
      //todo for not web case
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        uploadImage();
      },
      child: Column(
        children: [
          Container(
              height: 100,
              width: 100,
              color: Colors.white,
              child: imageUrl == null
                  ? Icon(Icons.image)
                  : Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                    )),
          Text('Upload Image'),
        ],
      ),
    );
  }
}
