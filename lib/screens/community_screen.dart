import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:neighbor_library/screens/detail_post_screen.dart';
import 'package:neighbor_library/screens/upload_community_post_screen.dart';
import 'package:neighbor_library/utilities/constants.dart';
import 'package:neighbor_library/widgets/progress_widget.dart';
import 'package:intl/intl.dart';

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  var menuList = ['코디고민', '중고 가격', '구매 고민', '스트릿'];
  String choiceCategory = '코디고민';
  int choicePostIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Get.to(CommunityScreen());
          },
          child: Text(
            'Community',
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
        actions: [
          IconButton(
            icon: Icon(Feather.edit_2),
            onPressed: () {
              showBarModalBottomSheet(
                  expand: true,
                  context: context,
                  builder: (context) => UploadCommunityPostScreen());
            },
            color: Colors.black,
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// 상단 선택 메뉴
          Container(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: menuList.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  // 선택한 컬렉션으로 바꿈
                  // print(CommunitySD[index]['title']);
                  setState(() {
                    choiceCategory = menuList[index];
                  });
                },
                child: Container(
                  padding: index == 0
                      ? EdgeInsets.only(left: 24)
                      : EdgeInsets.only(left: 10),
                  child: Container(
                    width: 90,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(6),
                        ),
                        color: menuList[index] == choiceCategory
                            ? Colors.blueAccent
                            : Colors.grey[200]),
                    child: Center(
                        child: Text(
                      menuList[index],
                      style: TextStyle(
                          color: menuList[index] == choiceCategory
                              ? Colors.white
                              : Colors.black,
                          fontWeight: menuList[index] == choiceCategory
                              ? FontWeight.bold
                              : null),
                    )),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            //로 크기를 줘야 에러가 Column안에 있더라도 에러가 안뜸
            child: ListView(
              children: [
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    // setState(() {
                    //   choicePostIndex = index;
                    // });
                    // Get.to(DetailPostScreen(), arguments: {
                    //   'postTitle': CommunitySD[index]['title'],
                    // });
                    // print(choicePostIndex);
                  },

                  /// 포스트 리스트
                  child: Container(
                    child: FutureBuilder<QuerySnapshot>(
                        future: communityRef
                            .doc(choiceCategory)
                            .collection('posts')
                            .get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return circularProgress();
                          }
                          final PostSN = snapshot.data.docs;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: PostSN.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 5),
                              child: InkWell(
                                onTap: () {
                                  // print(PostSN[index]['timestamp'].toDate);
                                  print(formatter.format(
                                      PostSN[index]['timestamp'].toDate()));

                                  // Get.to(DetailPostScreen(), arguments: {
                                  //   'choiceCaterogy': choiceCaterogy,
                                  //   'postId': PostSN[index]['postId'],
                                  //   'postTitle': PostSN[index]['postTitle'],
                                  //   'username': PostSN[index]['userInfo']
                                  //       ['username'],
                                  //   'postDescription': PostSN[index]
                                  //       ['postDescription'],
                                  // });
                                  Get.toNamed(
                                      "/DetailPostScreen?choiceCategory=${choiceCategory}&postId=${PostSN[index]['postId']}&postTitle=${PostSN[index]['postTitle']}&username=${PostSN[index]['userInfo']['username']}&postDescription=${PostSN[index]['postDescription']}&timestamp=${formatter.format(PostSN[index]['timestamp'].toDate())}");
                                },
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        PostSN[index]['postTitle'],
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        PostSN[index]['userInfo']['username'],
                                        style:
                                            TextStyle(color: Color(0xFF888888)),
                                      ),
                                      Divider(
                                        color: Color(0xff888888),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                )
                // Padding(
                //   padding: const EdgeInsets.only(left: 0),
                //   child: Text(
                //     snapshot.data.docs[index]['postTitle'].toString(),
                //     style:
                //         TextStyle(fontSize: 14, color: Color(0xFF222222)),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
