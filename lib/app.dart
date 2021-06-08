import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neighbor_library/screens/register_Style_screen.dart';
import 'package:neighbor_library/screens/upload_screen.dart';
import 'package:neighbor_library/screens/user_screen.dart';

// screens
import 'package:neighbor_library/services/controller/screen_controller.dart';
import 'screens/home_screen.dart';
// import 'package:trytousergetx/screens/time_line_screen.dart';
// import 'package:trytousergetx/screens/upload_screen.dart';
// import 'package:trytousergetx/screens/bookmark_screen.dart';
// import 'package:trytousergetx/screens/my_page_screen.dart';

//
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

// 바텀 네비게이션과 화면 관리
class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MyBottomNavigation();
  }
}

MyBottomNavigation() {
  return Scaffold(
    body: Obx(() {
      switch (RouteName.values[ScreenController.to.currentIndex.value]) {
        case RouteName.HomeScreen:
          return HomeScreen();
          break;

        case RouteName.UploadScreen:
          return MyPostScreen();
          break;
        case RouteName.RegisterStyleScreen:
          return RegisterStyleScreen();
          break;
        case RouteName.BookmarkScreen:
          return HomeScreen();
          break;
        case RouteName.UserScreen:
          return UserScreen();
          break;
      }
      return Container();
    }),
    bottomNavigationBar: Obx(
      () => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: ScreenController.to.currentIndex.value,
        showSelectedLabels: true,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black45,
        onTap: ScreenController.to.changeScreenIndex,
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Icon(Feather.home),
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Icon(Feather.compass),
              ),
              label: '라이브'),
          BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Icon(Feather.plus_circle),
              ),
              label: '추가'),
          BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Icon(Icons.bookmarks_outlined),
              ),
              label: '푸마크'),
          BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Icon(Feather.user),
              ),
              label: '유저'),
        ],
        selectedLabelStyle: TextStyle(fontSize: 11),
        unselectedLabelStyle: TextStyle(fontSize: 10),
      ),
    ),
  );
}
