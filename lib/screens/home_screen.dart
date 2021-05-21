import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neighbor_library/utilities/constants.dart';
import 'package:neighbor_library/widgets/progress_widget.dart';

TextEditingController bookTitleController = TextEditingController();
TextEditingController bookWriterController = TextEditingController();

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                '이웃집 도서관',
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              bottom: TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                    child: Text(
                      '책 빌리기',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Tab(
                    child: Text(
                      '책 등록하기',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              elevation: 0,
            ),
            body: TabBarView(
              children: [
                ListView(
                  children: [
                    StreamBuilder<DocumentSnapshot>(
                        stream: usersRef
                            .doc(authController.firebaseUser.uid)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return circularProgress();
                          }

                          return new ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: 1,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 빌린 책이 없다
                                  snapshot.data['rentCount'] == '0'
                                      ? Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Color(0xFFD6D9EA),
                                          ),
                                          height: Get.height / 2,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                    Text(
                                                      '현재 빌린 책이 없어요',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color:
                                                            Color(0xFF4A4A4A),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 30),
                                                    width: Get.width / 2,
                                                    color: Colors.black,
                                                  ),
                                                  // 사진 자리
                                                  Container(
                                                    width: Get.width,
                                                    height: 80,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: Color(0xFF4D88F5),
                                                    ),
                                                    child: Center(
                                                        child: Text(
                                                      '근처 책 둘러보기',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      // 빌린 책이 있다면
                                      : Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Color(0xFFEDDBDB),
                                          ),
                                          height: Get.height / 2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        color:
                                                            Color(0xFF0AFF00),
                                                      ),
                                                    ),
                                                    Text(
                                                      '현재 ${snapshot.data['rentCount']}권 이용중',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Color(
                                                              0xFF4A4A4A)),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 30),
                                                      width: Get.width / 2,
                                                      height:
                                                          Get.height / 2 - 170,
                                                      color: Colors.black,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 14,
                                                              bottom: 10),
                                                      child: Text(
                                                        '작은 별이지만 빛나고 있어',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Text('초록기린님의 책')
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 60),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '이도를 사용하는 이유',
                                          style: TextStyle(
                                            fontSize: Get.width / 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 22),
                                          height: 96,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Color(0xFFFFDFB8),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '고마워요\n이웃님',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    height: 1.5),
                                              ),
                                              Text('bb'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ],
                ),
                ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: TextFormField(
                              controller: bookTitleController,
                              decoration: InputDecoration(
                                labelText: "책 이름",
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              validator: (val) {
                                if (val.trim().length < 2 || val.isEmpty) {
                                  return '닉네임이 너무 짧아요. (< 5)';
                                } else if (val.trim().length > 15 ||
                                    val.isEmpty) {
                                  return '닉네임이 너무 길어요. (> 15)';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: TextFormField(
                              controller: bookWriterController,
                              decoration: InputDecoration(
                                labelText: "저자",
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              validator: (val) {
                                if (val.trim().length < 2 || val.isEmpty) {
                                  return '닉네임이 너무 짧아요. (< 5)';
                                } else if (val.trim().length > 15 ||
                                    val.isEmpty) {
                                  return '닉네임이 너무 길어요. (> 15)';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          RaisedButton(
                            onPressed: () {
                              print('click');
                            },
                            child: Text('등록하기'),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
