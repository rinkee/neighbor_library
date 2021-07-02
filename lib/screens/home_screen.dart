import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neighbor_library/screens/detail_my_look_screen.dart';
import 'package:neighbor_library/screens/user_get_items_screen.dart';
import 'package:neighbor_library/screens/item_screen.dart';
import 'package:neighbor_library/screens/upload_my_look_screen.dart';
import 'package:neighbor_library/utilities/constants.dart';
import 'package:neighbor_library/widgets/progress_widget.dart';
import 'package:intl/intl.dart';

int daySeconds = 86400;
double fontSIZE = 100;

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            'Facode',
            // style: TextStyle(
            //     color: Colors.black,
            //     fontWeight: FontWeight.bold,
            //     fontSize: 25),
            style: GoogleFonts.montserrat(
                fontSize: kMenuFontSize,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
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
                        const EdgeInsets.only(top: 14, bottom: 24, right: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 6월의 룩
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 24, bottom: 13),
                                child: Text(
                                  'SUMMER DAILY',
                                  // style: TextStyle(
                                  //   fontSize: Get.width / 14,
                                  //   fontWeight: FontWeight.bold,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                              snapshot.data['postCount'] >= 1
                                  ? Container(
                                      margin: EdgeInsets.only(bottom: 30),
                                      height: Get.height / 2,
                                      child: FutureBuilder<QuerySnapshot>(
                                          future: usersRef
                                              .doc(authController
                                                  .firebaseUser.uid)
                                              .collection('dailyLooks')
                                              .orderBy('timestamp',
                                                  descending: true)
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
                                              itemCount:
                                                  snapshot.data.docs.length > 5
                                                      ? 5
                                                      : snapshot
                                                          .data.docs.length,
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
                                                  padding: index == 0
                                                      ? EdgeInsets.only(
                                                          left: 24)
                                                      : EdgeInsets.only(
                                                          left: 20),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        width: Get.width - 170,
                                                        height: 350,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(20),
                                                          ),
                                                          image:
                                                              DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(
                                                              postSDD[index][
                                                                  'postImageURL'],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      // Image.network(
                                                      //   postSDD[index]
                                                      //       ['postImageURL'],
                                                      //   width: 210,
                                                      //   height:
                                                      //       Get.height / 2.5,
                                                      //   fit: BoxFit.cover,
                                                      // ),
                                                      SizedBox(height: 10),
                                                      Text(
                                                        postSDD[index]
                                                                ['postTitle']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      SizedBox(height: 3),
                                                      Text(
                                                        postSDD[index][
                                                                'postDescription']
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
                          padding: EdgeInsets.symmetric(vertical: 30),
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
                                      'Items',
                                      // style: TextStyle(
                                      //   fontSize: kMenuFontSize,
                                      //   fontWeight: FontWeight.bold,
                                      style: GoogleFonts.montserrat(
                                        fontSize: kMenuFontSize,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
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
                                      child: Text('more'),
                                    ),
                                  ),
                                ],
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  width: Get.width,
                                  height: 120,
                                  margin: EdgeInsets.only(top: 20),
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
                                            padding: index == 0
                                                ? EdgeInsets.only(
                                                    right: 7, left: 24)
                                                : EdgeInsets.only(
                                                    right: 7, left: 7),
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.to(
                                                  UserGetItemsScreen(),
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
                                                    top: 7, bottom: 10),
                                                width: 120,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFF2F1E9),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20),
                                                  ),
                                                  // boxShadow: [
                                                  //   BoxShadow(
                                                  //     color: Colors.grey
                                                  //         .withOpacity(0.3),
                                                  //     spreadRadius: 1,
                                                  //     blurRadius: 2,
                                                  //     offset: Offset(10,
                                                  //         10), // changes position of shadow
                                                  //   ),
                                                  // ],
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Image(
                                                      image: AssetImage(
                                                          'assets/icons/${snapshot.data.docs[index]['name']}.png'),
                                                      width: 60,
                                                    ),
                                                    Text(
                                                      snapshot.data
                                                          .docs[index]['count']
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff4D4D4D),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Text(
                                                      snapshot.data.docs[index]
                                                          ['name'],
                                                      style: TextStyle(
                                                        fontSize: 12,
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
                          child: new Container(
                            height: 10.0,
                            color: Colors.grey[100],
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
                                'Current Record',
                                // style: TextStyle(
                                //   fontSize: kMenuFontSize,
                                //   fontWeight: FontWeight.bold,
                                style: GoogleFonts.montserrat(
                                  fontSize: kMenuFontSize,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 24),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Daily Look',
                                                  style:
                                                      kDefaultCurrentRecordTextStyle),
                                              Text(
                                                  Duration(
                                                                  seconds: Timestamp
                                                                              .now()
                                                                          .seconds -
                                                                      snapshot
                                                                          .data[
                                                                              'lastUpdateDailyLook']
                                                                          .seconds)
                                                              .inDays ==
                                                          0
                                                      ? '오늘'
                                                      : '${Duration(seconds: Timestamp.now().seconds - snapshot.data['lastUpdateDailyLook'].seconds).inDays.toString()}일전',
                                                  style:
                                                      kDefaultCurrentRecordDateTextStyle),
                                            ],
                                          ),
                                          Divider(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Item',
                                                  style:
                                                      kDefaultCurrentRecordTextStyle),
                                              Text('3일전',
                                                  style:
                                                      kDefaultCurrentRecordDateTextStyle),
                                            ],
                                          ),
                                          Divider(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Buy',
                                                  style:
                                                      kDefaultCurrentRecordTextStyle),
                                              Text(
                                                  '${Duration(seconds: Timestamp.now().seconds - snapshot.data['lastUpdateBuyCloth'].seconds + daySeconds).inDays.toString()}일전',
                                                  style:
                                                      kDefaultCurrentRecordDateTextStyle),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          child: Center(
                                            // child: Text(
                                            //   formatter.format(snapshot
                                            //       .data['lastUpdateBuyCloth']
                                            //       .toDate()),
                                            //   style: TextStyle(
                                            //     fontSize: 16,
                                            //     fontWeight: FontWeight.bold,
                                            //   ),
                                            // ),
                                            child: Text(
                                              '프로 업로더',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          width: Get.width / 2.5,
                                          height: Get.width / 2.5,
                                          decoration: BoxDecoration(
                                              color: Color(0xFF6EDFFF),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                          child: new Container(
                            height: 10.0,
                            color: Colors.grey[100],
                          ),
                        ),

                        /// 선호 컬
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 30),
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
                                      'Favorite Colors',
                                      // style: TextStyle(
                                      //   fontSize: kMenuFontSize,
                                      //   fontWeight: FontWeight.bold,
                                      style: GoogleFonts.montserrat(
                                        fontSize: kMenuFontSize,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 24),
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(ItemScreen());
                                      },
                                      child: Text('more'),
                                    ),
                                  ),
                                ],
                              ),
                              snapshot.data['hasColor'] == true
                                  ? Container(
                                      height: Get.height / 5,
                                      margin: EdgeInsets.only(top: 24),
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
                                              scrollDirection: Axis.horizontal,
                                              itemCount: 5,
                                              itemBuilder: (context, index) =>
                                                  GestureDetector(
                                                child: Padding(
                                                  padding: index == 0
                                                      ? EdgeInsets.only(
                                                          left: 24,
                                                          right: 10,
                                                        )
                                                      : EdgeInsets.only(
                                                          left: 10, right: 10),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: 120,
                                                        height: 120,
                                                        decoration: BoxDecoration(
                                                            color: Color(snapshot.data.docs[index]['color']),
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(
                                                                  100),
                                                            ),
                                                            // 컬러가 흰색이면 보더를 생성
                                                            border: snapshot.data.docs[index]['color'] == 4294967295 ? Border.all(color: Colors.grey[200]) : null
                                                            // boxShadow: [
                                                            //   BoxShadow(
                                                            //     color: snapshot.data
                                                            //                     .docs[index]
                                                            //                 [
                                                            //                 'color'] ==
                                                            //             4294967295
                                                            //         ? Colors
                                                            //             .grey[300]
                                                            //             .withOpacity(
                                                            //                 0.5)
                                                            //         : Color(snapshot
                                                            //                     .data
                                                            //                     .docs[index]
                                                            //                 [
                                                            //                 'color'])
                                                            //             .withOpacity(
                                                            //                 0.5),
                                                            //     spreadRadius: 1,
                                                            //     blurRadius: 2,
                                                            //     offset: Offset(5,
                                                            //         5), // changes position of shadow
                                                            //   ),
                                                            // ],
                                                            ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        snapshot.data
                                                                .docs[index]
                                                            ['name'],
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xFF505050)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    )
                                  : Text('no data'),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                          child: new Container(
                            height: 10.0,
                            color: Colors.grey[100],
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
