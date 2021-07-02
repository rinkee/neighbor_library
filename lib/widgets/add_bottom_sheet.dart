import 'package:flutter/material.dart';
//
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:neighbor_library/screens/upload_my_look_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AddBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              print('코디 등록');
              showCupertinoModalBottomSheet(
                expand: false,
                context: context,
                builder: (context) => UploadMyLookScreen(
                  fromLook: true,
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(100)),
                  child: Icon(
                    MaterialIcons.accessibility_new,
                    size: 40,
                  ),
                ),
                SizedBox(height: 5),
                Text('코디 등록')
              ],
            ),
          ),
          InkWell(
            onTap: () {
              print('아이템 등록');
              showBarModalBottomSheet(
                expand: true,
                context: context,
                builder: (context) => UploadMyLookScreen(
                  fromLook: false,
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(100)),
                  child: Icon(
                    MaterialIcons.checkroom,
                    size: 40,
                  ),
                ),
                SizedBox(height: 5),
                Text('아이템 등록')
              ],
            ),
          )
        ],
      ),
    );
  }
}
