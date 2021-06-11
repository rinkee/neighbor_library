import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neighbor_library/screens/item_screen.dart';
import 'package:neighbor_library/screens/register_Style_screen.dart';
import 'package:neighbor_library/utilities/constants.dart';
import 'package:neighbor_library/widgets/progress_widget.dart';
import 'package:intl/intl.dart';

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
                    padding:
                        const EdgeInsets.only(top: 24, bottom: 24, right: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 6월의 룩
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 24),
                              child: Text(
                                '6월의 룩',
                                style: TextStyle(
                                  fontSize: Get.width / 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 15.0),
                              height: Get.height / 2.5,
                              child: FutureBuilder<QuerySnapshot>(
                                  future: postsRef
                                      .where('userInfo.uId',
                                          isEqualTo:
                                              authController.firebaseUser.uid)
                                      .get(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return circularProgress();
                                    }

                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data.docs.length,
                                      itemBuilder: (context, index) =>
                                          Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Image.network(
                                              snapshot.data.docs[index]
                                                  ['postImageURL'],
                                              width: Get.width,
                                              height: Get.height / 3.5,
                                              fit: BoxFit.cover,
                                            ),
                                            Text(
                                              snapshot
                                                  .data.docs[index]['postTitle']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              snapshot
                                                  .data.docs[index]['postTitle']
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF222222),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        width: 160,
                                      ),
                                    );
                                  }),
                            ),
                            Divider(
                              height: 0,
                            ),
                          ],
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
                                        print(snapshot
                                            .data['lastUpdateDailyLook']);
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
                                        child: Center(
                                            child: Text(formatter.format(
                                                snapshot
                                                    .data['lastUpdateDailyLook']
                                                    .toDate()))),
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
                                        child: Center(
                                            child: Text(formatter.format(
                                                snapshot
                                                    .data['lastUpdateBuyCloth']
                                                    .toDate()))),
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
