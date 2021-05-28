import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class VideoPick extends StatefulWidget {
  final String? folderPath;
  final Function imageUpdateHandler;
  final String? selectedVideo;

  VideoPick({
    this.folderPath,
    required this.imageUpdateHandler,
    this.selectedVideo,
  });

  @override
  State<VideoPick> createState() => _VideoPickState();
}

class _VideoPickState extends State<VideoPick> {
  bool uploading = false;

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
    if (widget.folderPath != null) {
      finalPath = (widget.folderPath as String) + "/" + uuid + filename;
    } else {
      finalPath = Uuid().v4() + uuid + filename;
    }

    return finalPath;
  }

  void pickVideoAndUploadToFirebase() async {
    if (kIsWeb) {
      try {
        html.FileUploadInputElement uploadInput = html.FileUploadInputElement()
          ..accept = 'video/*';
        uploadInput.click();

        uploadInput.onChange.listen((event) {
          final file = uploadInput.files!.first;
          final fileName = uploadInput.files!.single.name;
          final reader = html.FileReader();
          reader.readAsDataUrl(file);
          reader.onLoad.listen((event) async {
            var firebaseStoragePath =
                getFirebaseStorageFilePath(fileName, true);
            setState(() {
              uploading = true;
            });
            var task = await FirebaseStorage.instance
                .ref(firebaseStoragePath)
                .putBlob(file);
            setState(() {
              uploading = false;
            });
            String url = await task.ref.getDownloadURL();
            print('url is $url');

            //todo: delete the older item
            //keep a log of all the not required images in some
            // list/map and delete them at the time of save/cancel
            // FirebaseStorage.instance.refFromURL(selectedImage as String)
            //     .delete();

            widget.imageUpdateHandler(url);
          });
        });
      } catch (ex) {
        //TODO: handle exception
      }
    } else {
      //android + iOS as image_picker only supports these
      final picker = ImagePicker();
      final pickedFile = await picker.getVideo(source: ImageSource.gallery);
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

        widget.imageUpdateHandler(url);
      } else {
        //TODO
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
            onPressed: () {
              pickVideoAndUploadToFirebase();
            },
            child: (widget.selectedVideo == null || widget.selectedVideo == '')
                ? Icon(Icons.video_library)
                : Text('Uploaded')),
        Visibility(
          child: CircularProgressIndicator(),
          visible: uploading,
        ),
      ],
    );
  }
}
