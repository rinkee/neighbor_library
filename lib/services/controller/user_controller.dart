import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MyUser {
  String id;
  String username;
  String photoURL;
  MyUser({
    @required String id,
    @required String username,
    @required String photoURL,
  })  : this.id = id,
        this.username = username,
        this.photoURL = photoURL;
}

class UserController extends GetxController {
  var user = new MyUser(
    id: '',
    username: '',
    photoURL: '',
  ).obs;

  change({
    @required String id,
    @required String username,
    @required String photoURL,
  }) {
    user.update((val) {
      val.id = id;
      val.username = username;
      val.photoURL = photoURL;
    });
  }
}
