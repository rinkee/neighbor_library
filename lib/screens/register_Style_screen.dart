import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:neighbor_library/utilities/constants.dart';

// for upload
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as ImD;
import 'package:path_provider/path_provider.dart';

String _ColorValue;

class RegisterStyleScreen extends StatefulWidget {
  @override
  _RegisterStyleScreenState createState() => _RegisterStyleScreenState();
}

class _RegisterStyleScreenState extends State<RegisterStyleScreen> {
  TextEditingController postTitleController = TextEditingController();
  String postId = Uuid().v4();
  final ImagePicker _picker = ImagePicker();
  File imgFile;

  @override
  void dispose() {
    // TODO: implement dispose
    postTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              imgFile == null
                  ? Text('No Image')
                  : Image.file(File(imgFile.path)),
              RaisedButton(
                onPressed: _getImage,
                child: Text('이미지'),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    changeColorValue(
                        value: 'red', number: 1, Colour: Colors.red),
                    changeColorValue(
                        value: 'orange', number: 5, Colour: Colors.orange),
                    changeColorValue(
                        value: 'yellow', number: 2, Colour: Colors.yellow),
                    changeColorValue(
                        value: 'green', number: 3, Colour: Colors.green),
                    changeColorValue(
                        value: 'blue', number: 4, Colour: Colors.blue),
                    changeColorValue(
                        value: 'purple', number: 5, Colour: Colors.purple),
                    changeColorValue(
                        value: 'white', number: 5, Colour: Colors.white),
                    changeColorValue(
                        value: 'grey', number: 5, Colour: Colors.grey),
                    changeColorValue(
                        value: 'black', number: 5, Colour: Colors.black),
                  ],
                ),
              ),
              // Text(_ColorValue),
              TextField(
                controller: postTitleController,
              ),
              // Padding(
              //   padding: EdgeInsets.all(20),
              //   child: TextFormField(
              //     controller: bookWriterController,
              //     decoration: InputDecoration(
              //       labelText: "저자",
              //       enabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10.0),
              //       ),
              //     ),
              //     validator: (val) {
              //       if (val.trim().length < 2 || val.isEmpty) {
              //         return '닉네임이 너무 짧아요. (< 5)';
              //       } else if (val.trim().length > 15 || val.isEmpty) {
              //         return '닉네임이 너무 길어요. (> 15)';
              //       } else {
              //         return null;
              //       }
              //     },
              //   ),
              // ),
              RaisedButton(
                onPressed: () {
                  controlUploadAndSave();
                  print('click');
                },
                child: Text('등록하기'),
              ),
            ],
          ),
        )
      ],
    );
  }

  savePostInfoToFireStore({
    String url,
    String postTitle,
  }) {
    postsRef.doc(postId).set({
      'postId': postId,
      'postImageURL': url,
      'postTitle': postTitle,
      'timestamp': Timestamp.now(),
      'userInfo': {
        'uId': authController.firebaseUser.uid,
        'userPhotoURL': authController.firebaseUser.photoURL,
        'username': userController.user.value.username,
      },
      'counts': {
        'likesCount': 0,
        'commentsCount': 0,
      },
    });
  }

  Future _getImage() async {
    PickedFile image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      this.imgFile = File(image.path);
    });
  }

  Future<String> uploadPhoto(mImgFile) async {
    firebase_storage.UploadTask storageUploadTask = bookStorageRef
        .child('$postId.jpg')
        .putFile(mImgFile); // 파일명을 지정해서 Storage에 저장
    firebase_storage.TaskSnapshot storageTaskSnapshot =
        await storageUploadTask; // 저장이 완료되면
    return await storageTaskSnapshot.ref.getDownloadURL(); // 저장된 url값을 return
  }

  compressingPhoto() async {
    // 업로드 전 사진 준비
    final tDirectory = await getTemporaryDirectory(); // path_provider에서 제공
    final path = tDirectory.path; // 임시 path를 만들어서
    ImD.Image mImageFile =
        ImD.decodeImage(imgFile.readAsBytesSync()); // image file을 읽어서
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(
          ImD.encodeJpg(mImageFile, quality: 90)); // jpg양식의 신규파일로 만듦
    setState(() {
      imgFile = compressedImageFile;
    });
  }

  clearPostInfo() {
    postId = Uuid().v4();
    postTitleController.clear();
    setState(() {
      imgFile = null;
    });
  }

  controlUploadAndSave() async {
    await compressingPhoto(); // 업로드 전 사진 준비
    String downloadUrl = await uploadPhoto(imgFile); // 업로드 후 url 저장
    savePostInfoToFireStore(
      url: downloadUrl,
      postTitle: postTitleController.text,
    ); // location은 에러나서 잠시 보류
    // usersRef
    //     .doc(currentUser.uid)
    //     .update({'postCount': FieldValue.increment(1)});
    clearPostInfo();
  }

  GestureDetector changeColorValue({String value, int number, Color Colour}) {
    return GestureDetector(
      onTap: () => setState(() {
        _ColorValue = value;
        // _servicePlaceOpacity = 1.0;
        print(_ColorValue);
      }),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.all(Radius.circular(100)),
          color: Colour,
        ),
        height: 30,
        width: 30,
      ),
    );
  }
}
