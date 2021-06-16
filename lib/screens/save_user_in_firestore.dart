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

class SaveUserInFirestoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Enter User NickName",
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
              RaisedButton(
                color: Colors.lightBlue,
                onPressed: () {
                  saveUserInfoToFirestore();
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => MyApp()));
                  Get.back();
                  Get.to(MyApp());
                },
                child: Text('Submit'),
              ),
            ],
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
          'bio': '',
          'email': user.email,
          // 'followerCount': 0,
          'uId': user.uid,
          'postCount': 0,
          'profileName': user.displayName,
          'timestamp': Timestamp.now(),
          'photoURL': user.photoURL,
          'username': nameController.text,
          'lastUpdateDailyLook': Timestamp.now(),
          'lastUpdateBuyCloth': Timestamp.now(),
        })
        .then((value) => print("User Add firestore"))
        .catchError((error) => print("Failed to add user: $error"));
    // cap
    usersRef
        .doc(user.uid)
        .collection('items')
        .doc('cap')
        .set({'count': 0, 'name': 'cap'})
        .then((value) => print("cap Add firestore"))
        .catchError((error) => print("Failed to add user: $error"));
    // glasses
    usersRef
        .doc(user.uid)
        .collection('items')
        .doc('glasses')
        .set({'count': 0, 'name': 'glasses'})
        .then((value) => print("glasses Add firestore"))
        .catchError((error) => print("Failed to add user: $error"));
    // t-shirt
    usersRef
        .doc(user.uid)
        .collection('items')
        .doc('t-shirt')
        .set({'count': 0, 'name': 't-shirt'})
        .then((value) => print("t-shirt Add firestore"))
        .catchError((error) => print("Failed to add user: $error"));
    // dress
    usersRef
        .doc(user.uid)
        .collection('items')
        .doc('dress')
        .set({'count': 0, 'name': 'dress'})
        .then((value) => print("dress Add firestore"))
        .catchError((error) => print("Failed to add user: $error"));
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
        .catchError((error) => print("Failed to add user: $error"));
    // skirt
    usersRef
        .doc(user.uid)
        .collection('items')
        .doc('skirt')
        .set({'count': 0, 'name': 'skirt'})
        .then((value) => print("skirt Add firestore"))
        .catchError((error) => print("Failed to add user: $error"));
    // shoes
    usersRef
        .doc(user.uid)
        .collection('items')
        .doc('shoes')
        .set({'count': 0, 'name': 'shoes'})
        .then((value) => print("shoes Add firestore"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
