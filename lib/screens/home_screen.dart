import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neighbor_library/screens/item_screen.dart';
import 'package:neighbor_library/screens/register_Style_screen.dart';
import 'package:neighbor_library/utilities/constants.dart';
import 'package:neighbor_library/widgets/progress_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LOOKATME',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          StreamBuilder<DocumentSnapshot>(
              stream: usersRef.doc(authController.firebaseUser.uid).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return circularProgress();
                }

                return new ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: 1,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(
                        top: 24, left: 24, bottom: 24, right: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 6월의 룩
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '6월의 룩',
                                style: TextStyle(
                                  fontSize: Get.width / 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 15.0),
                                height: Get.height / 3.3,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            color: Colors.blue,
                                            height: 200,
                                          ),
                                          Text(
                                            '여친이 좋아하는 룩 오로로로로',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text('여친이 좋아하는 룩입니다 오로로로로'),
                                        ],
                                      ),
                                      width: 160,
                                    ),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            color: Colors.red,
                                            height: 200,
                                          ),
                                          Text(
                                            '여친이 좋아하는 룩',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text('여친이 좋아하는 룩입니다 오로로로로'),
                                        ],
                                      ),
                                      width: 160,
                                    ),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            color: Colors.green,
                                            height: 200,
                                          ),
                                          Text(
                                            '여친이 좋아하는 룩',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text('여친이 좋아하는 룩입니다 오로로로로'),
                                        ],
                                      ),
                                      width: 160,
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 0,
                              ),
                            ],
                          ),
                        ),
                        // 아이템
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '아이템',
                                    style: TextStyle(
                                      fontSize: Get.width / 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(ItemScreen());
                                      },
                                      child: Text('더보기'),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 20.0),
                                height: 85,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      width: 85.0,
                                      color: Colors.red,
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/icons/006-cap.png',
                                            width: 50,
                                          ),
                                          Text('hat'),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 85.0,
                                      color: Colors.blue,
                                    ),
                                    Container(
                                      width: 85.0,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 0,
                              ),
                            ],
                          ),
                        ),
                        // 최근기록
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '최근기록',
                                style: TextStyle(
                                  fontSize: Get.width / 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        child:
                                            Center(child: Text('21년 4월 20일')),
                                        width: Get.width / 2.5,
                                        height: Get.width / 2.5,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                      ),
                                      Text('데일리룩')
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        child:
                                            Center(child: Text('21년 4월 20일')),
                                        width: Get.width / 2.5,
                                        height: Get.width / 2.5,
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                      ),
                                      Text('구매')
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
