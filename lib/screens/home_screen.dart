import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neighbor_library/screens/detail_my_look_screen.dart';
import 'package:neighbor_library/screens/detail_view_item_screen.dart';
import 'package:neighbor_library/screens/item_screen.dart';
import 'package:neighbor_library/screens/upload_my_look_screen.dart';
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
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
                              snapshot.data['postCount'] >= 1
                                  ? Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 15.0),
                                      height: Get.height / 2.5,
                                      child: FutureBuilder<QuerySnapshot>(
                                          future: postsRef
                                              .where('userInfo.uId',
                                                  isEqualTo: authController
                                                      .firebaseUser.uid)
                                              .get(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return circularProgress();
                                            }
                                            final postSDD = snapshot.data.docs;
                                            return ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: 5,
                                              itemBuilder: (context, index) =>
                                                  GestureDetector(
                                                onTap: () {
                                                  Get.to(DetailMyLookScreen(),
                                                      arguments: {
                                                        'postTitle':
                                                            postSDD[index]
                                                                ['postTitle'],
                                                        'postImageURL': postSDD[
                                                                index]
                                                            ['postImageURL'],
                                                      });
                                                },
                                                child: Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Image.network(
                                                        postSDD[index]
                                                            ['postImageURL'],
                                                        width: Get.width,
                                                        height:
                                                            Get.height / 3.5,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Text(
                                                        postSDD[index]
                                                                ['postTitle']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Text(
                                                        postSDD[index]
                                                                ['postTitle']
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Color(0xFF222222),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                  width: 160,
                                                ),
                                              ),
                                            );
                                          }),
                                    )
                                  : Container(
                                      height: Get.height / 5,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '아직 기록한 룩이 없으시군요...!',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20,
                                                left: 20,
                                                right: 20,
                                                bottom: 20),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: ButtonTheme(
                                                minWidth: Get.width,
                                                buttonColor: Colors.blue[500],
                                                height: 56,
                                                child: RaisedButton(
                                                  onPressed: () {
                                                    Get.to(
                                                        UploadMyLookScreen());
                                                  },
                                                  child: Text(
                                                    '나의 룩 등록해 보기',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                          child: new Center(
                            child: new Container(
                              height: 10.0,
                              color: Colors.grey[100],
                            ),
                          ),
                        ),

                        /// 아이템
                        Padding(
                          padding: EdgeInsets.only(top: 30, bottom: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24),
                                    child: Text(
                                      '아이템',
                                      style: TextStyle(
                                        fontSize: Get.width / 16,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  width: Get.width,
                                  height: 100,
                                  margin: EdgeInsets.only(top: 13),
                                  child: FutureBuilder<QuerySnapshot>(
                                      future: usersRef
                                          .doc(authController.firebaseUser.uid)
                                          .collection('items')
                                          .get(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return circularProgress();
                                        }

                                        return ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: snapshot.data.docs.length,
                                          itemBuilder: (context, index) =>
                                              Padding(
                                            padding: const EdgeInsets.only(
                                                right: 7, left: 7),
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.to(
                                                  DetailViewItemScreen(),
                                                  arguments: {
                                                    "snapshotIndex": snapshot
                                                        .data.docs[index],
                                                  },
                                                );
                                                Get.toNamed(
                                                    'DetailViewItemScreen()/value');
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFF2F1E9),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20),
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.3),
                                                      spreadRadius: 1,
                                                      blurRadius: 2,
                                                      offset: Offset(10,
                                                          10), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Image(
                                                      image: AssetImage(
                                                          'assets/icons/${snapshot.data.docs[index]['name']}.png'),
                                                      width: 50,
                                                    ),
                                                    Text(
                                                      snapshot.data
                                                          .docs[index]['count']
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff4D4D4D),
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot.data.docs[index]
                                                          ['name'],
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFF4D4D4D),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                          child: new Center(
                            child: new Container(
                              height: 10.0,
                              color: Colors.grey[100],
                            ),
                          ),
                        ),
                        // 최근기록
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 30),
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
                              Padding(
                                padding: const EdgeInsets.only(top: 13),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          child: Center(
                                              child: Text(
                                            formatter.format(snapshot
                                                .data['lastUpdateDailyLook']
                                                .toDate()),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )),
                                          width: Get.width / 2.5,
                                          height: Get.width / 2.5,
                                          decoration: BoxDecoration(
                                              color: Color(0xFFF2E9EF),
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            '데일리룩',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF505050)),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          child: Center(
                                              child: Text(
                                            formatter.format(snapshot
                                                .data['lastUpdateBuyCloth']
                                                .toDate()),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )),
                                          width: Get.width / 2.5,
                                          height: Get.width / 2.5,
                                          decoration: BoxDecoration(
                                              color: Color(0xFFE9F0F2),
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            '구매',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF505050)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),

                        /// 선호 컬
                        Padding(
                          padding: EdgeInsets.only(top: 30, bottom: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24),
                                    child: Text(
                                      '선호 컬러',
                                      style: TextStyle(
                                        fontSize: Get.width / 16,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                              snapshot.data['hasColor'] == true
                                  ? SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Container(
                                        width: Get.width,
                                        height: 120,
                                        margin: EdgeInsets.only(top: 13),
                                        child: FutureBuilder<QuerySnapshot>(
                                            future: usersRef
                                                .doc(authController
                                                    .firebaseUser.uid)
                                                .collection('colors')
                                                .orderBy('count',
                                                    descending: true)
                                                .get(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return circularProgress();
                                              }
                                              return ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    snapshot.data.docs.length,
                                                itemBuilder: (context, index) =>
                                                    Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10,
                                                          left: 10,
                                                          bottom: 15),
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        top: 10, bottom: 10),
                                                    width: 100,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                      color: Color(snapshot
                                                              .data.docs[index]
                                                          ['color']),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(20),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: snapshot.data.docs[
                                                                          index]
                                                                      [
                                                                      'color'] ==
                                                                  4294967295
                                                              ? Colors.grey[300]
                                                                  .withOpacity(
                                                                      0.5)
                                                              : Color(snapshot
                                                                          .data
                                                                          .docs[index]
                                                                      ['color'])
                                                                  .withOpacity(
                                                                      0.5),
                                                          spreadRadius: 1,
                                                          blurRadius: 2,
                                                          offset: Offset(10,
                                                              10), // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Text(
                                                          snapshot
                                                              .data
                                                              .docs[index]
                                                                  ['count']
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xff4D4D4D),
                                                          ),
                                                        ),
                                                        Text(
                                                          snapshot.data
                                                                  .docs[index]
                                                              ['name'],
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xFF4D4D4D),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    )
                                  : Text('no data'),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                          child: new Center(
                            child: new Container(
                              height: 10.0,
                              color: Colors.grey[100],
                            ),
                          ),
                        ),
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
