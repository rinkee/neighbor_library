import 'package:flutter/material.dart';
import 'package:get/get.dart';
// font
import 'package:google_fonts/google_fonts.dart';
// screen
import 'package:neighbor_library/app.dart';
// binding
import 'binding/instance_binding.dart';
// firebase
import 'package:firebase_core/firebase_core.dart';
// controller
import 'services/controller/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialBinding: InstanceBinding(),
    theme: ThemeData(
      textTheme: GoogleFonts.notoSansTextTheme(),
    ),
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  final authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: authController.checkUserLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error Processing');
          }
          if (snapshot.hasData) {
            return snapshot.data;
          }
          return buildLoading();
        });
  }

  Widget buildLoading() => Center(child: CircularProgressIndicator());
}
