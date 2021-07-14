import 'package:flutter/material.dart';
// firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// state management
import 'package:get/get.dart';
// google login
import 'package:google_sign_in/google_sign_in.dart';
// controller
import 'package:neighbor_library/utilities/constants.dart';
// screen
import '../main.dart';

final _formKey = GlobalKey<FormState>();
TextEditingController nameController = TextEditingController();
int gender;
double manBoxOpacity = 1.0;
double womanBoxOpacity = 1.0;

class SaveUserInFirestoreScreen extends StatefulWidget {
  @override
  _SaveUserInFirestoreScreenState createState() =>
      _SaveUserInFirestoreScreenState();
}

class _SaveUserInFirestoreScreenState extends State<SaveUserInFirestoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '성별',
                  style: TextStyle(
                    fontSize: Get.width / 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 13, bottom: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              gender = 1;
                              manBoxOpacity = 1.0;
                              womanBoxOpacity = 0.5;
                              print(gender);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xFFF2E9EF)
                                    .withOpacity(manBoxOpacity),
                                borderRadius: BorderRadius.circular(20)),
                            height: Get.width / 2.2,
                            child: Center(
                              child: Text(
                                '남',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                        .withOpacity(manBoxOpacity)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              gender = 2;
                              womanBoxOpacity = 1.0;
                              manBoxOpacity = 0.5;
                              print(gender);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xFFF2E9EF)
                                    .withOpacity(womanBoxOpacity),
                                borderRadius: BorderRadius.circular(20)),
                            height: Get.width / 2.2,
                            child: Center(
                              child: Text(
                                '여',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                        .withOpacity(womanBoxOpacity)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '닉네임',
                  style: TextStyle(
                    fontSize: Get.width / 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 13),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "닉네임을 입력해 주세요",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (val) {
                      if (val.trim().length < 2 || val.isEmpty) {
                        return '닉네임이 너무 짧아요. (< 5)';
                      } else if (val.trim().length > 15 || val.isEmpty) {
                        return '닉네임이 너무 길어요. (> 15)';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 24, right: 24),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ButtonTheme(
                      minWidth: Get.width,
                      height: 56,
                      child: RaisedButton(
                        onPressed: () {
                          saveUserInfoToFirestore();
                          Get.back();
                          Get.offAll(MyApp());
                          print('유저 등록 완료');
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
          ),
        ),
      ),
    );
  }
}

saveUserInfoToFirestore() async {
  final gCurrentUser = GoogleSignIn().currentUser;
  // !! googleSignIn().currentUser 에서 유저 값을 받아오면 id 가 null값이 뜸;;
  // FireAuth에서 유저 값을 받아와야함

  // 현재 구글 로그인된 사용자 정보 가져오기
  final user = await FirebaseAuth.instance.currentUser;
  // 해당 유저의 db정보 가져오기
  DocumentSnapshot documentSnapshot = await usersRef.doc(user.uid).get();

  // 해당 유저의 db정보가 없다면
  if (!documentSnapshot.exists) {
    // 유저정보 셋팅된 값으로 db에 set
    usersRef
        .doc(user.uid)
        .set({
          'uId': user.uid,
          'uPhotoURL': user.photoURL,
          'uProfileName': user.displayName,
          'uNickName': nameController.text,
          'uEmail': user.email,
          'gender': gender,
          'postCount': 0,
          'haveItem': false,
          'haveColor': false,
          'haveNotification': false,
          'createAccountDate': Timestamp.now(),
          'lastUploadBuy': Timestamp.now(),
          'lastUploadLook': Timestamp.now(),
        })
        .then((value) => print("User Add firestore"))
        .catchError((error) => print("Failed to add user: $error"));
    userController.fbuser.clear();
    userController.fetchUser(user.uid);
    userController.fbuser.refresh();
    print('add user info in FB && update userModelList !!');

    // cap
    usersRef
        .doc(user.uid)
        .collection('items')
        .doc('cap')
        .set({'count': 0, 'name': 'cap'})
        .then((value) => print("cap Add firestore"))
        .catchError((error) => print("Failed to add cap: $error"));
    // glasses
    usersRef
        .doc(user.uid)
        .collection('items')
        .doc('glasses')
        .set({'count': 0, 'name': 'glasses'})
        .then((value) => print("glasses Add firestore"))
        .catchError((error) => print("Failed to add glasses: $error"));
    // t-shirt
    usersRef
        .doc(user.uid)
        .collection('items')
        .doc('t-shirt')
        .set({'count': 0, 'name': 't-shirt'})
        .then((value) => print("t-shirt Add firestore"))
        .catchError((error) => print("Failed to add t-shirt: $error"));

    // jeans
    usersRef
        .doc(user.uid)
        .collection('items')
        .doc('jeans')
        .set({'count': 0, 'name': 'jeans'})
        .then((value) => print("jeans Add firestore"))
        .catchError((error) => print("Failed to add user: $error"));
    // shorts-pants
    usersRef
        .doc(user.uid)
        .collection('items')
        .doc('shorts-pants')
        .set({'count': 0, 'name': 'shorts-pants'})
        .then((value) => print("shorts-pants Add firestore"))
        .catchError((error) => print("Failed to add shorts-pants: $error"));

    // shoes
    usersRef
        .doc(user.uid)
        .collection('items')
        .doc('shoes')
        .set({'count': 0, 'name': 'shoes'})
        .then((value) => print("shoes Add firestore"))
        .catchError((error) => print("Failed to add shoes: $error"));
    if (gender == 1) {
      // skirt
      usersRef
          .doc(user.uid)
          .collection('items')
          .doc('skirt')
          .set({'count': 0, 'name': 'skirt'})
          .then((value) => print("skirt Add firestore"))
          .catchError((error) => print("Failed to add skirt: $error"));

      // dress
      usersRef
          .doc(user.uid)
          .collection('items')
          .doc('dress')
          .set({'count': 0, 'name': 'dress'})
          .then((value) => print("dress Add firestore"))
          .catchError((error) => print("Failed to add dress: $error"));
    }
  }
}
