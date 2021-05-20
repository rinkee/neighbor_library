import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                    text: '책 빌리기',
                  ),
                  Tab(
                    text: '책 등록하기',
                  ),
                ],
              ),
              elevation: 0,
            ),
            body: TabBarView(
              children: [
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFFEDDBDB),
                            ),
                            height: Get.height / 2,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Color(0xFF0AFF00),
                                        ),
                                      ),
                                      Text(
                                        '현재 1권 이용중',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xFF4A4A4A)),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 30),
                                        width: Get.width / 2,
                                        height: Get.height / 2 - 170,
                                        color: Colors.black,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 14, bottom: 10),
                                        child: Text(
                                          '작은 별이지만 빛나고 있어',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '이도를 사용하는 이유',
                                  style: TextStyle(
                                    fontSize: Get.width / 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 22),
                                  height: 96,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
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
                  ],
                ),
                Text('bb'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
