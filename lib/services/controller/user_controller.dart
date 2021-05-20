import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MyUser {
  String id;
  String username;
  MyUser({
    @required String id,
    @required String username,
  })  : this.id = id,
        this.username = username;
}

class UserController extends GetxController {
  var user = new MyUser(
    id: '',
    username: '',
  ).obs;

  change({
    @required String id,
    @required String username,
  }) {
    user.update((val) {
      val.id = id;
      val.username = username;
    });
  }
}
