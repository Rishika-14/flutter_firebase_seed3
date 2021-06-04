import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:universal_html/html.dart' as html;
import 'package:uuid/uuid.dart';

class ImagePick extends StatelessWidget {
  final String? folderPath;
  final Function imageUpdateHandler;
  final String? selectedImage;

  const ImagePick({
    this.folderPath,
    required this.imageUpdateHandler,
    this.selectedImage,
  });

  /**
   * Generate a firebase savable path based on filename and weather uuid
   * should be used.
   */
  getFirebaseStorageFilePath(String filename, bool addUUid) {
    String uuid = '';
    if (addUUid) {
      uuid = Uuid().v4() + "-";
    }
    String finalPath = '';
    if (folderPath != null) {
      finalPath = (folderPath as String) + "/" + uuid + filename;
    } else {
      finalPath = Uuid().v4() + uuid + filename;
    }

    return finalPath;
  }

  void pickImageAndUploadToFirebase() async {
    if (kIsWeb) {
      try {
        html.FileUploadInputElement uploadInput = html.FileUploadInputElement()
          ..accept = 'image/*';
        uploadInput.click();

        uploadInput.onChange.listen((event) {
          final file = uploadInput.files!.first;
          final fileName = uploadInput.files!.single.name;
          final reader = html.FileReader();
          reader.readAsDataUrl(file);
          reader.onLoad.listen((event) async {
            var firebaseStoragePath =
                getFirebaseStorageFilePath(fileName, true);
            var task = await FirebaseStorage.instance
                .ref(firebaseStoragePath)
                .putBlob(file);

            String url = await task.ref.getDownloadURL();
            print('url is $url');

            //todo: delete the older item
            //keep a log of all the not required images in some
            // list/map and delete them at the time of save/cancel
            // FirebaseStorage.instance.refFromURL(selectedImage as String)
            //     .delete();

            imageUpdateHandler(url);
          });
        });
      } catch (ex) {
        //TODO: handle exception
      }
    } else {
      //android + iOS as image_picker only supports these
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      // final pickedFile = await picker.getImage(source: ImageSource.camera);
      if (pickedFile != null) {
        File file = File(pickedFile.path);
        String filename = basename(file.path);

        var firebaseStoragePath = getFirebaseStorageFilePath(filename, true);
        var task = await FirebaseStorage.instance
            .ref(firebaseStoragePath)
            .putFile(file);

        String url = await task.ref.getDownloadURL();
        print('url is $url');

        //todo: delete the older item
        //keep a log of all the not required images in some
        // list/map and delete them at the time of save/cancel
        // FirebaseStorage.instance.refFromURL(selectedImage as String)
        //     .delete();

        imageUpdateHandler(url);
      } else {
        //TODO
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pickImageAndUploadToFirebase();
      },
      child: Column(
        children: [
          Container(
              height: 100,
              width: 100,
              color: Colors.white,
              child: (selectedImage == null || selectedImage == '')
                  ? Icon(Icons.upload)
                  : Image.network(
                      selectedImage!,
                      fit: BoxFit.cover,
                    )),
        ],
      ),
    );
  }
}
