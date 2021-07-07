import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neighbor_library/services/controller/noti_contriller.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final notiController = Get.put(NotiController());
  @override
  final Size preferredSize;

  final String title;

  CustomAppBar(
    this.title, {
    Key key,
  })  : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        IconButton(
            icon: Icon(
              Icons.add,
              color: Color(notiController.chaneColor.value),
            ),
            onPressed: () {})
      ],
      backgroundColor: Colors.white,
      automaticallyImplyLeading: true,
    );
  }
}
