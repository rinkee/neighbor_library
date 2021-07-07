import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:neighbor_library/utilities/constants.dart';
import 'package:neighbor_library/widgets/add_bottom_sheet.dart';

enum RouteName {
  HomeScreen,
  MyLookScreen,
  Add,
  CommunityScreen,
  UserScreen,
}

class ScreenController extends GetxService {
  static ScreenController get to => Get.find();
  RxInt currentIndex = 0.obs;

  void changeScreenIndex(int index) {
    if (RouteName.values[index] == RouteName.Add) {
      _showBottomSheet();
    } else {
      currentIndex(index);
    }
  }

  void _showBottomSheet() {
    Get.bottomSheet(AddBottomSheet());
  }
}

//TODO 코디 고민, 구매 고민 등 메뉴를 초기에 불러와서 저장하는 모델값을 만들자
class MenuList {
  String title;
  MenuList({
    @required String title,
  }) : this.title = title;
}

class MenuListController extends GetxController {
  var menuList = new MenuList(
    title: '',
  ).obs;

  change({
    @required String title,
  }) {
    menuList.update((val) {
      val.title = title;
    });
  }
}
