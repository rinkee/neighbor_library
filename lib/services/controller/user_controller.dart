import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:neighbor_library/utilities/constants.dart';
import 'package:neighbor_library/models/user_model.dart';
import 'dart:async';

class MyUser {
  String id;
  String username;
  String photoURL;
  bool isSeemed;
  MyUser({
    @required String id,
    @required String username,
    @required String photoURL,
    @required bool isSeemed,
  })  : this.id = id,
        this.username = username,
        this.photoURL = photoURL,
        this.isSeemed = false;
}

class UserController extends GetxController {
  var fbuser = [].obs;

  Rx<UserModel> usermodel = UserModel().obs;

  @override
  onReady() {
    super.onReady();
    usermodel.bindStream(listenToUser());
  }

  // StreamController<bool> streamController = StreamController<bool>();
  // // the path from where our data will be fetched and displayed to used
  // Stream<DocumentSnapshot> doc =
  //     usersRef.doc(authController.firebaseUser.uid).snapshots();
  //
  // void StartStream() {
  //   doc.listen((event) {
  //     // here count is a field name in firestore database
  //     streamController.sink.add(event.data()['count']);
  //   });
  // }
  //
  // @override
  // FutureOr onClose() {
  //   streamController.close();
  // }

// 패치해서 한곳에 저장
  void fetchUser(String currentuId) async {
    await usersRef.doc(currentuId).get().then((value) {
      fbuser.add(UserModel.fromJson(value.data()).toJson());
      print(fbuser);
    });
  }

  void fetchUser1(String currentuId) async {
    await usersRef.doc(currentuId).get().then((value) {
      fbuser.add(UserModel.fromJson(value.data()).toJson());
      print(fbuser);
    });
  }

  Stream<UserModel> listenToUser() => usersRef
      .doc(authController.firebaseUser.uid)
      .snapshots()
      .map((snapshot) => UserModel.fromSnapshot(snapshot));

  // void clearUser() {
  //   fbuser.clear();
  // }
}
