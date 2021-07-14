import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neighbor_library/screens/aa.dart';
import 'package:neighbor_library/screens/community_screen.dart';
import 'package:neighbor_library/screens/sample.dart';
import 'package:neighbor_library/services/controller/post_controller.dart';
import 'package:neighbor_library/utilities/constants.dart';
import 'package:neighbor_library/widgets/progress_widget.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';

// for upload
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image/image.dart' as ImD;
import 'package:path_provider/path_provider.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final PC = Get.put(PostController());
  String postId = Uuid().v4();
  final ImagePicker _picker = ImagePicker();
  File imgFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'userpage',
      //     style: TextStyle(color: Colors.black),
      //   ),
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      // ),
      backgroundColor: Colors.white,
      body: FutureBuilder<DocumentSnapshot>(
          future: usersRef.doc(authController.firebaseUser.uid).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return circularProgress();
            }
            return ListView(
              children: [
                SizedBox(height: 100),
                Column(
                  children: [
                    CupertinoContextMenu(
                        actions: [
                          CupertinoContextMenuAction(
                            child: Text('프로필 사진 변경'),
                            onPressed: () {
                              _getImage();
                            },
                          ),
                          CupertinoContextMenuAction(
                            child: Text('저장'),
                            onPressed: () {
                              controlUploadAndSave();
                            },
                          ),
                          CupertinoContextMenuAction(
                            child: Text('Report this image'),
                            onPressed: () {
                              // Your logic here
                              // Close the context menu
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: imgFile == null
                                    ? NetworkImage(snapshot.data['uPhotoURL'])
                                    : FileImage(imgFile)),
                          ),
                        )),
                    // GestureDetector(
                    //   onTap: () {
                    //     CupertinoContextMenuAction(
                    //       child: Text('Add to Favorites'),
                    //       onPressed: () {
                    //         // Your logic here
                    //         // Close the context menu
                    //         Navigator.of(context).pop();
                    //       },
                    //     );
                    //   },
                    //   child: Container(
                    //     width: 150,
                    //     height: 150,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.all(
                    //         Radius.circular(20),
                    //       ),
                    //       image: DecorationImage(
                    //         fit: BoxFit.cover,
                    //         image: NetworkImage(snapshot.data['photoURL']),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Obx(() => Text('${PC.lookPostList[0]['postId']}')),
                    RaisedButton(
                      onPressed: () {
                        Get.to(CommunityScreen());
                      },
                      child: Text('CommunityScreen'),
                    ),
                    RaisedButton(
                      onPressed: () {
                        print(userController.fbuser);
                      },
                      child: Text('aa'),
                    ),
                    SizedBox(height: 20),
                    Text(
                      snapshot.data['uNickName'],
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      snapshot.data['uEmail'],
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) =>
                              CupertinoActionSheet(
                                  title: const Text('정말 로그아웃 하시겠습니까?'),
                                  message: const Text('데이터는 손실 되지 않습니다.'),
                                  actions: <Widget>[
                                    CupertinoActionSheetAction(
                                      child: const Text('로그아웃'),
                                      onPressed: () {
                                        authController.signOut();
                                      },
                                      isDestructiveAction: true,
                                    )
                                  ],
                                  cancelButton: CupertinoActionSheetAction(
                                    child: const Text('취소'),
                                    isDefaultAction: true,
                                    onPressed: () {
                                      Navigator.pop(context, 'Cancel');
                                    },
                                  )),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 5),
                        child: Container(
                          width: Get.width,
                          height: 70,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 20),
                              Icon(
                                Icons.logout,
                                size: 35,
                              ),
                              SizedBox(width: 20),
                              Text(
                                '로그아웃',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 5),
                        child: Container(
                          width: Get.width,
                          height: 70,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 20),
                              Icon(
                                Icons.logout,
                                size: 35,
                              ),
                              SizedBox(width: 20),
                              Text(
                                '다크모드',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            );
          }),
    );
  }

  /// Get from gallery
  Future _getImage() async {
    PickedFile image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      this.imgFile = File(image.path);
    });
    // _cropImage(image.path);
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

  controlUploadAndSave() async {
    await compressingPhoto(); // 업로드 전 사진 준비
    String downloadUrl = await uploadPhoto(imgFile);
    changeUserPhoto(url: downloadUrl);
  }

  changeUserPhoto({
    String url,
  }) {
    usersRef.doc(authController.firebaseUser.uid).update({
      'photoURL': url,
    });
  }
}
