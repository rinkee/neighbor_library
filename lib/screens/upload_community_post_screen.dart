import 'package:flutter/material.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:neighbor_library/utilities/constants.dart';
import 'package:neighbor_library/widgets/progress_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// for upload
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image/image.dart' as ImD;
import 'package:path_provider/path_provider.dart';

class UploadCommunityPostScreen extends StatefulWidget {
  @override
  _UploadCommunityPostScreenState createState() =>
      _UploadCommunityPostScreenState();
}

class _UploadCommunityPostScreenState extends State<UploadCommunityPostScreen> {
  // text i
  var i = 1;
  // 제목, 메모 컨트롤
  TextEditingController postTitleController = TextEditingController();
  TextEditingController postDescriptionController = TextEditingController();
  // 포스터 id, 이미지 저장
  String postId = Uuid().v4();
  final ImagePicker _picker = ImagePicker();
  File imgFile;

  // 로딩 화면 컨트롤
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
    return Stack(children: [
      GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              '게시물 등록',
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    print(menuList[1].toString());
                  })
            ],
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          backgroundColor: Colors.white,
          body: ListView(
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        showCupertinoModalBottomSheet(
                          expand: false,
                          context: context,
                          builder: (context) => UploadCommunityPostScreen(),
                        );
                      },
                      child: Text('aa'),
                    ),

                    /// 이미지 선택 영역
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

                    /// 카테고리 선택
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40, bottom: 10),
                          child: Text(
                            '카테고리를 선택하세요',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF888888),
                            ),
                          ),
                        ),
                        Container(
                          height: 45,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: menuList.length,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                // 선택한 컬렉션으로 바꿈
                                setState(() {
                                  choiceCategory = menuList[index].toString();
                                });
                                print(choiceCategory);
                              },
                              child: Container(
                                padding: EdgeInsets.only(right: 10),
                                child: Container(
                                  width: 90,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                      color: menuList[index].toString() ==
                                              choiceCategory
                                          ? Colors.blueAccent
                                          : Colors.grey[200]),
                                  child: Center(
                                      child: Text(
                                    menuList[index].toString(),
                                    style: TextStyle(
                                        color: menuList[index].toString() ==
                                                choiceCategory
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight:
                                            menuList[index].toString() ==
                                                    choiceCategory
                                                ? FontWeight.bold
                                                : null),
                                  )),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// 제목
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            '제목 ',
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
                              hintText: '제목을 입력해 주세요 ',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              labelText: '${i}'),
                          maxLines: null,
                        ),
                      ],
                    ),

                    /// 내용
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            '내용 ',
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
                            hintText: '자유롭게 내용을 입력해 주세요',
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

                    /// 등록 버튼
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
                              controlUploadAndSave();
                              Get.snackbar('커뮤니티', '게시물 등록을 완료하였습니다.',
                                  snackPosition: SnackPosition.TOP);
                              i++;
                              print('update post');
                            },
                            child: Text(
                              '게시글 등록',
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
      ),
      Visibility(
          visible: _isDialogVisible,
          child: Container(
            color: Colors.black54,
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: CircularProgressIndicator(
                strokeWidth: 10,
                valueColor: AlwaysStoppedAnimation(Colors.black),
                backgroundColor: Colors.grey,
              ),
            ),
          ))
    ]);
  }

  saveCommunityPostToFireStore(
      {String url, String postTitle, String postDescription}) {
    communityRef.doc(postId).set({
      'category': choiceCategory,
      'postId': postId,
      'postImageURL': url,
      'postTitle': postTitle,
      'postDescription': postDescriptionController.text,
      'timestamp': Timestamp.now(),
      'userInfo': {
        'uId': authController.firebaseUser.uid,
        'PhotoURL': authController.firebaseUser.photoURL,
        'username': userController.fbuser[0]['uNickName'],
      },
      'countLike': 0,
      'countComment': 0,
      'likes': {}
    });
    usersRef
        .doc(authController.firebaseUser.uid)
        .collection('community')
        .doc(postId)
        .set({
      'category': choiceCategory,
      'postId': postId,
      'postImageURL': url,
      'postTitle': postTitle,
      'postDescription': postDescriptionController.text,
      'timestamp': Timestamp.now(),
      'userInfo': {
        'uId': authController.firebaseUser.uid,
        'PhotoURL': authController.firebaseUser.photoURL,
        'username': userController.fbuser[0]['uNickName'],
      },
      'countLike': 0,
      'countComment': 0,
      'likes': {}
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
    firebase_storage.UploadTask storageUploadTask = postStorageRef

        ///TODO: 새로운 저장소 만들기
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
    // postTitleController.clear();
    // postDescriptionController.clear();
    setState(() {
      imgFile = null;
    });
  }

  controlUploadAndSave() async {
    if (imgFile != null) {
      await compressingPhoto(); // 업로드 전 사진 준비
      String downloadUrl = await uploadPhoto(imgFile);
      // 업로드 후 url 저장
      saveCommunityPostToFireStore(
        url: downloadUrl,
        postTitle: postTitleController.text,
        postDescription: postDescriptionController.text,
      );

      clearPostInfo();
      print('사진이 있는 게시물 등록에 성공했습니다');
    } else {
      saveCommunityPostToFireStore(
        url: '',
        postTitle: postTitleController.text,
        postDescription: postDescriptionController.text,
      );

      clearPostInfo();
      print('사진이 없는 게시물 등록에 성공했습니다');
    }
  }
}
