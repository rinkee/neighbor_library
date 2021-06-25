import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:neighbor_library/app.dart';
import 'package:neighbor_library/screens/upload_my_look_screen.dart';

class myModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '추가',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Container(
                height: 210,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                icon:
                                    const Icon(MaterialIcons.accessibility_new),
                                color: Colors.white,
                                iconSize: 60,
                                tooltip: 'Increase volume by 10',
                                onPressed: () {},
                              ),
                              SizedBox(height: 5),
                              Text(
                                '코디',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          showBarModalBottomSheet(
                            expand: false,
                            context: context,
                            builder: (context) => UploadMyLookScreen(
                              fromLook: true, // 트루로 접근하면 코디 추가
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showBarModalBottomSheet(
                            expand: true,
                            context: context,
                            builder: (context) => UploadMyLookScreen(
                              fromLook: false,
                            ),
                          );
                        },
                        child: Container(
                          width: 160,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.yellow[400]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(MaterialIcons.checkroom),
                                iconSize: 60,
                                tooltip: 'Increase volume by 10',
                                onPressed: () {},
                              ),
                              SizedBox(height: 5),
                              Text(
                                '아이템',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: Get.width,
                height: 170,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
