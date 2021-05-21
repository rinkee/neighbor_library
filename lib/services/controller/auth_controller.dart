import 'package:flutter/material.dart';
// state management
import 'package:get/get.dart';
// google login
import 'package:google_sign_in/google_sign_in.dart';
// firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

// screen
import 'package:neighbor_library/app.dart';
import 'package:neighbor_library/screens/login_screen.dart';
import 'package:neighbor_library/screens/save_user_in_firestore.dart';
// controller
import 'package:neighbor_library/services/controller/user_controller.dart';
import 'package:neighbor_library/utilities/constants.dart';

class AuthController extends GetxController {
  final userController = Get.put(UserController());
  // Intilize the flutter app
  FirebaseApp firebaseApp;
  User firebaseUser;
  FirebaseAuth firebaseAuth;

  Future<void> initlizeFirebaseApp() async {
    firebaseApp = await Firebase.initializeApp();
  }

  Future<Widget> checkUserLoggedIn() async {
    if (firebaseApp == null) {
      await initlizeFirebaseApp();
    }
    if (firebaseAuth == null) {
      firebaseAuth = FirebaseAuth.instance;
      update();
    }
    if (firebaseAuth.currentUser == null) {
      return LoginScreen();
    } else {
      firebaseUser = firebaseAuth.currentUser;
      // 로그인 했나 체크 후 정보 MyUser에 저장
      // TODO 유저 전환 후 업데이트가 되지않음 포스트를 올릴때 username이 그대로 저장된다는 문제가 있음
      // 모든 데이터를 firestored에서 가져와서 의미가 없어짐 .
      // usersRef
      //     .doc(authController.firebaseUser.uid)
      //     .get()
      //     .then((DocumentSnapshot documentSnapshot) {
      //   if (documentSnapshot.exists) {
      //     userController.change(
      //         id: authController.firebaseUser.uid,
      //         username: documentSnapshot.data()['user']);
      //
      //     print('current usermodel update');
      //   }
      // });
      update();
      return App();
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      // Show loading screen till we complete our login workflow
      Get.dialog(Center(child: buildLoading()), barrierDismissible: false);
      // for flutter fire we need to maker sure Firebase is initilzed before dong any auth related activity
      await initlizeFirebaseApp();
      // Create Firebase auth for storing auth related info such as logged in user etc.
      firebaseAuth = FirebaseAuth.instance;
      // Start of google sign in workflow
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredentialData =
          await FirebaseAuth.instance.signInWithCredential(credential);
      firebaseUser = userCredentialData.user;

      // 유저 정보가 저장 되있다면...
      final user = FirebaseAuth.instance.currentUser;
      DocumentSnapshot documentSnapshot = await usersRef.doc(user.uid).get();
      if (!documentSnapshot.exists) {
        update();
        Get.back();
        Get.to(SaveUserInFirestoreScreen());
        // 임시로 데이터가 없어도 app스크린으로 보냄
        // Get.offAll(App());
        print('user info not in cloud_store');
      } else {
        // userController.change(
        //     id: user.uid, username: documentSnapshot.data()['username']);
        print('current usermodel update');
        update();
        Get.back();
        Get.offAll(App());
        print('user info in cloud_store');
      }
    } catch (ex) {
      Get.back();
      // Show Error if we catch any error
      Get.snackbar('Sign In Error', 'Error Signing in',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.black,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          icon: Icon(
            Icons.error,
            color: Colors.red,
          ));
    }
  }

  Future<void> signOut() async {
    // Show loading widget till we sign out
    Get.dialog(Center(child: buildLoading()), barrierDismissible: false);
    await firebaseAuth.signOut();
    Get.back();
    // Navigate to Login again
    Get.offAll(LoginScreen());
  }
}

Widget buildLoading() => Center(child: CircularProgressIndicator());
