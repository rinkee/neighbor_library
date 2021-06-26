import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neighbor_library/screens/myModal.dart';
import 'package:neighbor_library/screens/upload_my_look_screen.dart';
import 'package:neighbor_library/screens/my_look_sreen.dart';
import 'package:neighbor_library/screens/user_screen.dart';

// screens
import 'package:neighbor_library/services/controller/screen_controller.dart';
import 'screens/home_screen.dart';
// import 'package:trytousergetx/screens/time_line_screen.dart';
// import 'package:trytousergetx/screens/my_look_sreen.dart';
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

        case RouteName.MyLookScreen:
          return MyLookScreen();
          break;
        case RouteName.myModal:
          return myModal();
          break;
        case RouteName.BookmarkScreen:
          return UploadMyLookScreen();
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
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 3),
              child: Icon(
                Feather.home,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Icon(
                  Feather.compass,
                ),
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Icon(
                  Feather.plus_circle,
                ),
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Icon(
                  Icons.bookmarks_outlined,
                ),
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 3),
                child: Icon(
                  Feather.user,
                ),
              ),
              label: ''),
        ],
        selectedLabelStyle: TextStyle(fontSize: 11),
        unselectedLabelStyle: TextStyle(fontSize: 10),
      ),
    ),
  );
}
