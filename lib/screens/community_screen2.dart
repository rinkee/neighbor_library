import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:neighbor_library/services/controller/post_controller.dart';
import 'package:neighbor_library/services/controller/screen_controller.dart';
import 'package:neighbor_library/services/controller/user_controller.dart';
import 'package:neighbor_library/utilities/constants.dart';
import 'package:neighbor_library/widgets/progress_widget.dart';
import 'package:intl/intl.dart';

class CommunityScreen2 extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen2> {
  final postController = Get.put(PostController());

  var getIsLiked = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoScaffold(
        body: Builder(
            builder: (context) => CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                    leading: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                          icon: Icon(Feather.edit_3),
                          onPressed: () {
                            CupertinoScaffold.showCupertinoModalBottomSheet(
                              expand: false,
                              context: context,
                              builder: (context) => UploadCommunityPostScreen(),
                            );
                          }),
                    ),
                    middle: Text('Community'),
                    trailing: Stack(
                      alignment: Alignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Feather.bell),
                          onPressed: () {
                            Get.to(ActiveScreen());

                            /// 유저가 볼 알람이 있ek fkrh 업데이트 해줌
                            usersRef
                                .doc(authController.firebaseUser.uid)
                                .update({'haveNotification': false});
                          },
                          color: Colors.black,
                        ),
                        Positioned(
                            right: 10,
                            top: 15,
                            child: Obx(() => Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                      color: userController
                                              .usermodel.value.haveNotification
                                          ? Colors.red
                                          : Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100))),
                                ))),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        /// 상단 선택 메뉴

                        Container(
                            margin: EdgeInsets.only(bottom: 5),
                            height: 40,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: menuListController.menuList.length,
                                itemBuilder: (context, index) => Obx(() {
                                      return GestureDetector(
                                        onTap: () {
                                          menuListController
                                              .currentIndex.value = index;
                                          postController.postList.clear();
                                          postController.fetchPostOneList(
                                              menuList[menuListController
                                                  .currentIndex.value]);
                                          postController.postList.refresh();
                                        },
                                        child: Container(
                                          padding: index == 0
                                              ? EdgeInsets.only(left: 14)
                                              : EdgeInsets.only(left: 5),
                                          child: Container(
                                            width: 70,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(6),
                                                ),
                                                color: index ==
                                                        menuListController
                                                            .currentIndex.value
                                                    ? Colors.white
                                                    : Colors.white),
                                            child: Center(
                                                child: Text(
                                              menuListController
                                                  .menuList[index],
                                              style: TextStyle(
                                                  color: index ==
                                                          menuListController
                                                              .currentIndex
                                                              .value
                                                      ? Colors.blue
                                                      : Colors.grey,
                                                  fontWeight: index ==
                                                          menuListController
                                                              .currentIndex
                                                              .value
                                                      ? FontWeight.bold
                                                      : null),
                                            )),
                                          ),
                                        ),
                                      );
                                    }))),

                        /// 포스트 리스트
                        Expanded(
//로 크기를 줘야 에러가 Column안에 있더라도 에러가 안뜸
                          child: PostView(
                            getPost: postController.postList,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CupertinoScaffold.showCupertinoModalBottomSheet(
            expand: false,
            context: context,
            builder: (context) => UploadCommunityPostScreen(),
          );
        },
        child: Icon(Feather.edit_3),
      ),
    );
  }
}

class PostView extends StatelessWidget {
  final postController = Get.put(PostController());
  dynamic getPost;
  PostView({this.getPost});
  @override
  Widget build(BuildContext context) {
    return Container(child: Obx(() {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: getPost.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
          child: InkWell(
            onTap: () async {
              var likesCount = getPost[index]['countLike'];
              var commentsCount = getPost[index]['countComment'];
              bool isLiked = getPost[index]['likes']
                      [authController.firebaseUser.uid] ==
                  authController.firebaseUser.uid;
              Get.toNamed(
                  "/DetailPostScreen?index=${index}&postId=${getPost[index]['postId']}&postTitle=${getPost[index]['postTitle']}&uId=${getPost[index]['userInfo']['uId']}&username=${getPost[index]['userInfo']['username']}&postDescription=${getPost[index]['postDescription']}&timestamp=${formatter.format(getPost[index]['timestamp'].toDate())}&commentsCount=${commentsCount}&likesCount=${likesCount}&isLiked=${isLiked}");
            },
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getPost[index]['postTitle'],
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getPost[index]['userInfo']['username'],
                        style: TextStyle(color: Colors.grey),
                      ),

                      /// 오른쪽 좋아요, 댓글 부분

                      Container(
                        width: 90,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 좋아요
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Feather.thumbs_up,
                                  color: Colors.grey[700],
                                  size: 14,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  getPost[index]['countLike'].toString(),
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ],
                            ),

                            SizedBox(width: 10),
                            // 댓글
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Feather.message_circle,
                                  color: Colors.grey[700],
                                  size: 14,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  getPost[index]['countComment'].toString(),
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          ],
                        ),
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
    }));
  }
}
