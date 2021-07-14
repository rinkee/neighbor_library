import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:neighbor_library/utilities/constants.dart';
import 'package:neighbor_library/widgets/progress_widget.dart';

// for upload
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image/image.dart' as ImD;
import 'package:path_provider/path_provider.dart';

String _ColorName;
Color myChoiceColor = null; // 유저가 선택한 컬러
int _ChoiceNumber = null; // db로 넘어가는 헥사코드 컬러값

class UploadMyLookScreen extends StatefulWidget {
  bool fromLook;
  UploadMyLookScreen({@required this.fromLook});
  @override
  _UploadMyLookScreenState createState() => _UploadMyLookScreenState();
}

class _UploadMyLookScreenState extends State<UploadMyLookScreen> {
  TextEditingController postTitleController = TextEditingController();
  TextEditingController postDescriptionController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemDescriptionController = TextEditingController();

  String postId = Uuid().v4();
  final ImagePicker _picker = ImagePicker();
  File imgFile;
  int selectItemIndex = 0;
  var myItemsList = ['cap', 'shoes', 'dress', 'glasses'];
  var myItemsListKR = [
    {
      'cap': '모자',
      'shoes': '신발',
      'dress': '드레스',
      'glasses': '안경',
    }
  ];

  bool _isDialogVisible = false;

  void _showDialog() {
    setState(() {
      _isDialogVisible = true;
    });
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isDialogVisible = false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    postTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              widget.fromLook == true ? 'Upload Look' : 'Upload Item',
            ),
          ),
          body: ListView(
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imgFile == null)
                      GestureDetector(
                        onTap: _getImage,
                        child: Container(
                            width: Get.width / 2 - 12,
                            height: Get.width / 2 - 12,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                // border: Border.all(
                                //     color: myChoiceColor == null
                                //         ? Colors.black
                                //         : myChoiceColor,
                                //     width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Center(child: Text('이미지를 선택하세요'))),
                      )
                    else
                      Stack(
                        children: [
                          Container(
                            width: Get.width / 2 - 12,
                            height: Get.width / 2 - 12,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black54,
                              //     spreadRadius: 3,
                              //     blurRadius: 10,
                              //     offset: Offset(
                              //         5, 5), // changes position of shadow
                              //   ),
                              // ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: Image.file(
                                File(imgFile.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: Icon(Feather.x),
                              color: Colors.black54,
                              onPressed: () {
                                setState(() {
                                  imgFile = null;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                    /// Select Color

                    Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Text(
                            '컬러',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: myChoiceColor == null
                                  ? Color(0xFF888888)
                                  : myChoiceColor,
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
                                  value: 'red',
                                  number: 0xFFF44336,
                                  choiceColor: Colors.red),
                              changeColorValue(
                                  value: 'orange',
                                  number: 0xFFFF9800,
                                  choiceColor: Colors.orange),
                              changeColorValue(
                                  value: 'yellow',
                                  number: 0xFFEB3B,
                                  choiceColor: Colors.yellow),
                              changeColorValue(
                                  value: 'green',
                                  number: 0xFF4CAF50,
                                  choiceColor: Colors.green),
                              changeColorValue(
                                  value: 'blue',
                                  number: 0xFF2196F3,
                                  choiceColor: Colors.blue),
                              changeColorValue(
                                  value: 'purple',
                                  number: 0xFF9C27B0,
                                  choiceColor: Colors.purple),
                              changeColorValue(
                                  value: 'white',
                                  number: 0xFFFFFFFF,
                                  choiceColor: Colors.white),
                              changeColorValue(
                                  value: 'grey',
                                  number: 0xFF9E9E9E,
                                  choiceColor: Colors.grey),
                              changeColorValue(
                                  value: 'black',
                                  number: 0xFF000000,
                                  choiceColor: Colors.black),
                            ],
                          ),
                        ),
                      ],
                    ),

                    /// 코디등록인 경우 화면
                    widget.fromLook == true
                        ? Wrap(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 30),
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
                                decoration: InputDecoration(
                                  hintText: '제목을 입력해 주세요',
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                                maxLines: null,
                              ),

                              /// 설명
                              Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Text(
                                  '메모',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF888888),
                                  ),
                                ),
                              ),
                              TextField(
                                controller: postDescriptionController,
                                decoration: InputDecoration(
                                  hintText: '메모를 입력해 주세요',
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                                maxLines: null,
                              ),
                            ],
                          )

                        /// 아이템 등록 화면
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Text(
                                  '분류',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF888888),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: InkWell(
                                    onTap: () {
                                      Get.bottomSheet(
                                        Container(
                                          height: Get.height / 3,
                                          decoration: BoxDecoration(
                                              color: Colors.white),
                                          child: CupertinoPicker(
                                              itemExtent: 50,
                                              onSelectedItemChanged: (value) {
                                                setState(() {
                                                  selectItemIndex = value;
                                                });

                                                print(value);
                                              },
                                              children: [
                                                for (var i in myItemsList)
                                                  Center(
                                                    child: Text(
                                                      myItemsListKR[0][i],
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                  )
                                              ]),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          myItemsListKR[0]
                                              [myItemsList[selectItemIndex]],
                                          style: TextStyle(
                                            fontSize: 25,
                                            color: Color(0xFF4A4A4A),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Column(
                                          children: [
                                            Icon(
                                              Feather.chevron_down,
                                              color: Color(0xFF4A4A4A),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            )
                                          ],
                                        )
                                      ],
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Text(
                                  '상품명',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF888888),
                                  ),
                                ),
                              ),
                              TextField(
                                controller: itemNameController,
                                decoration: InputDecoration(
                                  hintText: '상품명을 입력해 주세요',
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                                maxLines: null,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Text(
                                  '메모',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF888888),
                                  ),
                                ),
                              ),
                              TextField(
                                controller: itemDescriptionController,
                                decoration: InputDecoration(
                                  hintText: '자유롭게 메모를 입력해 주세요',
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                                maxLines: null,
                              ),
                            ],
                          ),

                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: ButtonTheme(
                          buttonColor: Colors.blueAccent,
                          minWidth: Get.width,
                          height: 56,
                          child: RaisedButton(
                            onPressed: () {
                              widget.fromLook == true
                                  ? controlUploadLookAndSave()
                                  : controlUploadItemAndSave();
                              Get.snackbar('나의 코디', '등록을 완료하였습니다.',
                                  snackPosition: SnackPosition.TOP);
                              print('update post');
                            },
                            child: Text(
                              widget.fromLook == true ? '코디 등록하기' : '아이템 등록하기',
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
        ),
        Visibility(
            visible: _isDialogVisible,
            child: Container(
              color: Colors.black54,
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation(Colors.black),
                  backgroundColor: Colors.grey,
                ),
              ),
            ))
      ],
    );
  }

  savePostFireStore({
    String url,
    String postTitle,
  }) {
    usersRef
        .doc(authController.firebaseUser.uid)
        .collection('dailyLooks')
        .doc(postId)
        .set({
      'postId': postId,
      'postImageURL': url,
      'postTitle': postTitle,
      'postDescription': postDescriptionController.text,
      'timestamp': Timestamp.now(),
      'userInfo': {
        'uId': authController.firebaseUser.uid,
        'userPhotoURL': authController.firebaseUser.photoURL,
        'username': userController.usermodel.value.uNickName,
      },
      'countLike': 0,
      'countComment': 0,
      'color': _ColorName,
      'color0xFF': _ChoiceNumber
    });
    print('add look');
  }

  saveItemInfoToFireStore({
    String url,
  }) {
    usersRef
        .doc(authController.firebaseUser.uid)
        .collection('items')
        .doc(myItemsList[selectItemIndex])
        .collection('itemList')
        .doc(postId)
        .set({
      'itemId': postId,
      'itemImageURL': url,
      'itemName': itemNameController.text,
      'timestamp': Timestamp.now(),
      'userInfo': {
        'uId': authController.firebaseUser.uid,
        'userPhotoURL': authController.firebaseUser.photoURL,
        'username': userController.usermodel.value.uNickName,
      },
      'countLike': 0,
      'countComment': 0,
      'category': myItemsList[selectItemIndex],
      'color': _ColorName,
      'color0xFF': _ChoiceNumber
    });
  }

  /// Get from gallery
  Future _getImage() async {
    PickedFile image = await _picker.getImage(source: ImageSource.gallery);
    _showDialog();
    _cropImage(image.path);
    setState(() {
      this.imgFile = File(image.path);
    });
  }

  // void _GetImageAndCrop() {
  //   _getImage();
  //   linearProgress();
  //   _cropImage(image.path);
  // }

  /// Crop Image
  _cropImage(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2
      ],
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
    postDescriptionController.clear();
    setState(() {
      imgFile = null;
      myChoiceColor = null;
    });
  }

  controlUploadLookAndSave() async {
    await compressingPhoto();
    String downloadUrl = await uploadPhoto(imgFile);

    savePostFireStore(
      url: downloadUrl,
      postTitle: postTitleController.text,
    );
    usersRef.doc(authController.firebaseUser.uid).update({
      'postCount': FieldValue.increment(1),
      'lastUpdateDailyLook': Timestamp.now(),
    });

    updateDateTime();
    clearPostInfo();
  }

  controlUploadItemAndSave() async {
    await compressingPhoto(); // 업로드 전 사진 준비
    String downloadUrl = await uploadPhoto(imgFile);
    // 업로드 후 url 저장
    saveItemInfoToFireStore(url: downloadUrl);
    usersRef
        .doc(authController.firebaseUser.uid)
        .collection('items')
        .doc(myItemsList[selectItemIndex])
        .update({'count': FieldValue.increment(1)});

    ///
    updateDateTime();
    clearPostInfo();
  }

  updateDateTime() async {
    //TODO 시간 없데이트는 아직
    DocumentSnapshot documentSnapshot = await usersRef
        .doc(authController.firebaseUser.uid)
        .collection('colors')
        .doc(_ColorName)
        .get();

    /// 만약 기존 값이 없다면 doc을 새로 생성후 값을 추가
    if (!documentSnapshot.exists)
      usersRef
          .doc(authController.firebaseUser.uid)
          .collection('colors')
          .doc(_ColorName)
          .set(
        {
          'count': FieldValue.increment(1),
          'name': _ColorName,
          'color': _ChoiceNumber,
        },
      );

    /// 기존 값이 있다면 count만 증가
    else {
      usersRef
          .doc(authController.firebaseUser.uid)
          .collection('colors')
          .doc(_ColorName)
          .update({'count': FieldValue.increment(1)});
    }
  }

  GestureDetector changeColorValue(
      {String value, int number, Color choiceColor}) {
    return GestureDetector(
      onTap: () => setState(() {
        _ColorName = value;
        // _servicePlaceOpacity = 1.0;
        myChoiceColor = choiceColor;
        _ChoiceNumber = number;
        print(_ColorName);
      }),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.all(Radius.circular(10)),
          color: choiceColor,
        ),
        height: 30,
        width: 30,
      ),
    );
  }
}
