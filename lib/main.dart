import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neighbor_library/app.dart';
import 'package:neighbor_library/screens/home_screen.dart';

import 'binding/instance_binding.dart';

void main() {
  runApp(GetMaterialApp(
    initialBinding: InstanceBinding(),
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: App(),
    );
  }
}
