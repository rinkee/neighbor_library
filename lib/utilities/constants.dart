// state managenment
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:google_fonts/google_fonts.dart';
// controller
import 'package:neighbor_library/services/controller/auth_controller.dart';
import 'package:neighbor_library/services/controller/database.dart';
import 'package:neighbor_library/services/controller/post_controller.dart';
import 'package:neighbor_library/services/controller/screen_controller.dart';
import 'package:neighbor_library/services/controller/user_controller.dart';
import 'package:intl/intl.dart';

final _firestore = FirebaseFirestore.instance;
final storageRef = firebase_storage.FirebaseStorage.instance.ref();
final firebase_storage.Reference bookStorageRef =
    storageRef.child('Books Pictures'); // 포스트 사진이 저장되는 폴

final firebase_storage.Reference postStorageRef =
    storageRef.child('Posts Pictures'); // 포스트 사진이 저장되는 폴
final usersRef = _firestore.collection('users');
final postsRef = _firestore.collection('posts');
final itemsRef = _firestore.collection('items');
final communityRef = _firestore.collection('community');
// final booksRef = _firestore.collection('books');
final followRef = _firestore.collection('follow');

// 컨트롤러 인식
var authController = Get.put(AuthController());
var userController = Get.put(UserController());
var menuListController = Get.put(MenuListController());
var dataController = Get.put(DataController());
var postController = Get.put(PostController());
// final postController = Get.put(PostController());

// time
final DateFormat formatter = DateFormat('yyyy년 MM월 dd일');

// menus
var menuList = ['코디고민', '중고 가격', '구매 고민', '11'];
String choiceCategory = '코디고민';

// size //
const double kEmojiContainerSize = 65;
const double kButtonSize = 35;
double kMenuFontSize = 23;
double kAppBarTitleFontSize = 25;

const kDefaultCurrentRecordTextStyle =
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

const kDefaultCurrentRecordDateTextStyle =
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54);
