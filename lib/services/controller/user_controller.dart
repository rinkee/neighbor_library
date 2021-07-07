import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:neighbor_library/utilities/constants.dart';
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
  var user = new MyUser(
    id: '',
    username: '',
    photoURL: '',
    isSeemed: false,
  ).obs;

  change({
    String id,
    String username,
    String photoURL,
    @required bool isSeemed,
  }) {
    user.update((val) {
      val.id = id;
      val.username = username;
      val.photoURL = photoURL;
      val.isSeemed = isSeemed;
    });
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
}
