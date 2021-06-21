import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailMyLookScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Get.arguments['title']),
      ),
    );
  }
}
