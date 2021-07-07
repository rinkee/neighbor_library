import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:neighbor_library/screens/aa.dart';
import 'package:neighbor_library/screens/active_screen.dart';
import 'package:neighbor_library/screens/detail_post_screen.dart';
import 'package:neighbor_library/screens/sample.dart';
import 'package:neighbor_library/screens/upload_community_post_screen.dart';
import 'package:neighbor_library/services/controller/noti_contriller.dart';
import 'package:neighbor_library/services/controller/user_controller.dart';
import 'package:neighbor_library/utilities/constants.dart';
import 'package:neighbor_library/widgets/progress_widget.dart';
import 'package:intl/intl.dart';

class CommunityScreen2 extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen2> {
  final notiController = Get.put(NotiController());
  var changeColor; // 벨의 알람 유뮤 상태를 나타냄

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot>(
                stream:
                    usersRef.doc(authController.firebaseUser.uid).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return circularProgress();
                  }
                  final SI = snapshot.data.get('isSeemed');
                  if (SI == true) {
                    notiController.changebool.value = true;
                    notiController.chaneColor.value = 0xFFFFFFFF;
                    notiController.changeText.value = '알람 있음';
                    changeColor = Colors.red;
                    print('NBV : ${notiController.changebool.value}');
                    print('NCV : ${notiController.chaneColor.value}');
                    print('NCT : ${notiController.changeText.value}');
                  } else {
                    notiController.changebool.value = false;
                    notiController.chaneColor.value = 0xFF000000;
                    notiController.changeText.value = '알람 없음';
                    changeColor = Colors.white;
                    print('NBV : ${notiController.changebool.value}');
                    print('NCV : ${notiController.chaneColor.value}');
                    print('NCT : ${notiController.changeText.value}');
                  }
                  print('isSeemed : ${SI}');
                  return Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 20),
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
                        Row(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Feather.bell),
                                  onPressed: () {
                                    Get.to(ActiveScreen());
                                    usersRef // DB의 값도 바꿔주
                                        .doc(authController.firebaseUser.uid)
                                        .update({'isSeemed': false});
                                  },
                                  color: Colors.black,
                                ),
                                Positioned(
                                    right: 11,
                                    top: 11,
                                    child: Container(
                                      width: 7,
                                      height: 7,
                                      decoration: BoxDecoration(
                                          color:
                                              notiController.changebool.value ==
                                                      true
                                                  ? Colors.red
                                                  : Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100))),
                                    )),
                              ],
                            ),
                            IconButton(
                                icon: Icon(Feather.edit),
                                onPressed: () {
                                  showBarModalBottomSheet(
                                    expand: true,
                                    context: context,
                                    builder: (context) =>
                                        UploadCommunityPostScreen(),
                                  );
                                })
                          ],
                        ),
                      ],
                    ),
                  ]);
                }),

            /// 상단 선택 메뉴

            Container(
              margin: EdgeInsets.only(bottom: 5),
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: menuList.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    // 선택한 컬렉션으로 바꿈
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

            Text(
              'haveNoti : ',
              style: TextStyle(color: Colors.black),
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
                              .where('category', isEqualTo: choiceCategory)
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
                                  onTap: () async {
                                    var postId = PostSN[index]['postId'];
                                    var postTitle = PostSN[index]['postTitle'];
                                    var uId = PostSN[index]['userInfo']['uId'];
                                    var username =
                                        PostSN[index]['userInfo']['username'];
                                    var timestamp = formatter.format(
                                        PostSN[index]['timestamp'].toDate());
                                    var likesCount =
                                        PostSN[index]['counts']['likesCount'];
                                    var commentsCount = PostSN[index]['counts']
                                        ['commentsCount'];
                                    bool isLiked = PostSN[index]['likes']
                                            [authController.firebaseUser.uid] ==
                                        authController.firebaseUser.uid;
                                    var value = await Get.toNamed(
                                        "/DetailPostScreen?postId=${postId}&postTitle=${postTitle}&uId=${uId}&username=${username}&postDescription=${PostSN[index]['postDescription']}&timestamp=${timestamp}&commentsCount=${commentsCount}&likesCount=${likesCount}&isLiked=${isLiked}");
                                    setState(() {
                                      isLiked = value;
                                    });
                                  },
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          PostSN[index]['postTitle'],
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black),
                                        ),
                                        SizedBox(height: 3),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              PostSN[index]['userInfo']
                                                  ['username'],
                                              style: TextStyle(
                                                  color: Colors.grey[800]),
                                            ),

                                            /// 오른쪽 좋아요, 댓글 부분
                                            Row(
                                              children: [
                                                // 좋아요
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Feather.thumbs_up,
                                                      color: Colors.grey[700],
                                                      size: 14,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      PostSN[index]['counts']
                                                              ['likesCount']
                                                          .toString(),
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[700]),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(width: 10),
                                                // 댓글
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Feather.message_circle,
                                                      color: Colors.grey[700],
                                                      size: 14,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      PostSN[index]['counts']
                                                              ['commentsCount']
                                                          .toString(),
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[700]),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
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
      ),
    );
  }
}
