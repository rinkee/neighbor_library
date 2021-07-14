import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neighbor_library/screens/community_screen.dart';
import 'package:neighbor_library/screens/community_screen2.dart';
import 'package:neighbor_library/screens/myModal.dart';
import 'package:neighbor_library/screens/upload_my_look_screen.dart';
import 'package:neighbor_library/screens/my_look_sreen.dart';
import 'package:neighbor_library/screens/user_screen.dart';
import 'package:neighbor_library/screens/user_screen2.dart';

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

        case RouteName.CommunityScreen:
          return CommunityScreen2();
          break;
        case RouteName.UserScreen:
          return UserScreen2();
          break;
        case RouteName.Add:
          // bottomSheet;
          break;
      }
      return Container();
    }),
    bottomNavigationBar: Obx(
      () => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: ScreenController.to.currentIndex.value,
        showSelectedLabels: true,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[500],
        onTap: ScreenController.to.changeScreenIndex,
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 5, left: 10, bottom: 3),
              child: Icon(
                Feather.home,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 3),
                child: Icon(
                  Feather.compass,
                ),
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 3),
                child: Icon(
                  Feather.plus_circle,
                  size: 40,
                ),
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 3),
                child: Icon(
                  Feather.link,
                ),
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 5, right: 10, bottom: 3),
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
