import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neighbor_library/utilities/constants.dart';

// for upload
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image/image.dart' as ImD;
import 'package:path_provider/path_provider.dart';

String _ColorValue;
Color choiceColorBorber = Colors.red;

class RegisterStyleScreen extends StatefulWidget {
  @override
  _RegisterStyleScreenState createState() => _RegisterStyleScreenState();
}

class _RegisterStyleScreenState extends State<RegisterStyleScreen> {
  TextEditingController postTitleController = TextEditingController();
  TextEditingController postDescriptionController = TextEditingController();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '코디 등록',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 24, right: 24, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imgFile == null
                    ? Container(
                        height: 300,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: choiceColorBorber, width: 5),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('no image'),
                              RaisedButton(
                                onPressed: _getImage,
                                child: Text('이미지'),
                              ),
                            ],
                          ),
                        ))
                    : Container(
                        width: Get.width,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: choiceColorBorber, width: 7),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Image.file(
                            File(imgFile.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                /// Select Color
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                    '컬러',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF888888),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      changeColorValue(
                          value: 'red', number: 1, choiceColor: Colors.red),
                      changeColorValue(
                          value: 'orange',
                          number: 5,
                          choiceColor: Colors.orange),
                      changeColorValue(
                          value: 'yellow',
                          number: 2,
                          choiceColor: Colors.yellow),
                      changeColorValue(
                          value: 'green', number: 3, choiceColor: Colors.green),
                      changeColorValue(
                          value: 'blue', number: 4, choiceColor: Colors.blue),
                      changeColorValue(
                          value: 'purple',
                          number: 5,
                          choiceColor: Colors.purple),
                      changeColorValue(
                          value: 'white', number: 5, choiceColor: Colors.white),
                      changeColorValue(
                          value: 'grey', number: 5, choiceColor: Colors.grey),
                      changeColorValue(
                          value: 'black', number: 5, choiceColor: Colors.black),
                    ],
                  ),
                ),
                // Text(_ColorValue),
                /// 제목
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text(
                    '제목',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF888888),
                    ),
                  ),
                ),
                TextField(
                  controller: postTitleController,
                ),

                /// 설명
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text(
                    '설명',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF888888),
                    ),
                  ),
                ),
                TextField(
                  controller: postDescriptionController,
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ButtonTheme(
                      minWidth: Get.width,
                      height: 56,
                      child: RaisedButton(
                        onPressed: () {
                          controlUploadAndSave();
                          print('update post');
                        },
                        child: Text(
                          '등록하기',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
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

  /// Get from gallery
  Future _getImage() async {
    PickedFile image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      this.imgFile = File(image.path);
    });
    _cropImage(image.path);
  }

  /// Crop Image
  _cropImage(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (croppedImage != null) {
      imgFile = croppedImage;
      setState(() {});
    }
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
    usersRef.doc(authController.firebaseUser.uid).update({
      'postCount': FieldValue.increment(1),
      'lastUpdateDailyLook': Timestamp.now(),
    });
    DocumentSnapshot documentSnapshot = await usersRef
        .doc(authController.firebaseUser.uid)
        .collection('colors')
        .doc(_ColorValue)
        .get();

    /// 만약 기존 값이 없다면 doc을 새로 생성후 값을 추가
    if (!documentSnapshot.exists)
      usersRef
          .doc(authController.firebaseUser.uid)
          .collection('colors')
          .doc(_ColorValue)
          .set(
        {
          'count': FieldValue.increment(1),
          'name': _ColorValue,
        },
      );

    /// 기존 값이 있다면 count만 증가
    else {
      usersRef
          .doc(authController.firebaseUser.uid)
          .collection('colors')
          .doc(_ColorValue)
          .update({'count': FieldValue.increment(1)});
    }
    clearPostInfo();
  }

  GestureDetector changeColorValue(
      {String value, int number, Color choiceColor}) {
    return GestureDetector(
      onTap: () => setState(() {
        _ColorValue = value;
        // _servicePlaceOpacity = 1.0;
        choiceColorBorber = choiceColor;
        print(_ColorValue);
      }),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.all(Radius.circular(100)),
          color: choiceColor,
        ),
        height: 30,
        width: 30,
      ),
    );
  }
}
