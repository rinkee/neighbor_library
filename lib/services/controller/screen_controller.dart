import 'package:get/get.dart';

enum RouteName {
  HomeScreen,
  UploadScreen,
  BookmarkScreen,
  MyPageScreen,
}

class ScreenController extends GetxService {
  static ScreenController get to => Get.find();
  RxInt currentIndex = 0.obs;

  void changeScreenIndex(int index) {
    currentIndex(index);
  }
}
