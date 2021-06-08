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
          'rentCount': 0,
          // 'followerCount': 0,
          'uId': user.uid,
          'postCount': 0,
          'profileName': user.displayName,
          'timestamp': Timestamp.now(),
          'photoURL': user.photoURL,
          'username': nameController.text,
        })
        .then((value) => print("User Add firestore"))
        .catchError((error) => print("Failed to add user: $error"));

    itemsRef
        .doc(user.uid)
        .set({
          'Hat': 0,
        })
        .then((value) => print("items Add firestore"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
