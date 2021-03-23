import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../widgets.dart';

class Uploader extends StatefulWidget {
  File imageFile;
  String username;

  Uploader(this.imageFile, this.username);

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://begoody-app.appspot.com');

  StorageUploadTask _uploadTask;

  void _startUpload() async {
    String filePath = 'images/${DateTime.now()}.png';

    StorageReference ref = _storage.ref().child(filePath);

    setState(() {
      _uploadTask = ref.putFile(widget.imageFile);
    });

    var dowUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();

    Firestore.instance
        .collection('provider')
        .document(widget.username)
        .updateData({
      'profilePhoto': dowUrl.toString(),
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    _startUpload();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Manage the task state and event subscription with a StreamBuilder
    return StreamBuilder<StorageTaskEvent>(
        stream: _uploadTask.events,
        builder: (_, snapshot) {
          var event = snapshot?.data?.snapshot;

          double progressPercent =
              event != null ? event.bytesTransferred / event.totalByteCount : 0;

          return Column(
            children: [
              if (_uploadTask.isComplete) Text('Completed'),

              if (_uploadTask.isPaused)
                FlatButton(
                  child: Icon(Icons.play_arrow),
                  onPressed: _uploadTask.resume,
                ),

              if (_uploadTask.isInProgress)
                FlatButton(
                  child: Icon(Icons.pause),
                  onPressed: _uploadTask.pause,
                ),

              // Progress bar
              LinearProgressIndicator(value: progressPercent),
              Text('${(progressPercent * 100).toStringAsFixed(2)} % '),

              if (_uploadTask.isComplete)
                Sb(h: 15),
              if (_uploadTask.isComplete)
                DialogButton(
                    child: Text(
                      "CLOSE",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
            ],
          );
        });
  }
}
