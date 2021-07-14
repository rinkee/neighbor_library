import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
//func
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neighbor_library/services/controller/database.dart';
import 'package:neighbor_library/services/controller/post_controller.dart';
import 'package:uuid/uuid.dart';
//screen
import 'package:neighbor_library/screens/community_screen.dart';
import 'package:neighbor_library/screens/home_screen.dart';
import 'package:neighbor_library/utilities/constants.dart';
import 'package:neighbor_library/widgets/progress_widget.dart';

/// 이 페이지의 문제점
/// get.param으로 값을 가져오는중이라 수정시 변화 감지가 어려울수있음
class DetailPostScreen extends StatefulWidget {
  @override
  _DetailPostScreenState createState() => _DetailPostScreenState();
}

class _DetailPostScreenState extends State<DetailPostScreen> {
  final postController = Get.put(PostController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postController.fetchCommentOneList(Get.parameters['postId']);
    postController.isLiked.value = getLiked;
    postController.commentsCount.value = getCommentsCount;
    postController.likesCount.value = getLikesCount;
  }

  TextEditingController commentController = TextEditingController();
  String commentId = Uuid().v4();
  String reCommentId = Uuid().v4();
  bool reCommenting = false;
  String getCommentId;

  // Get으로 받아온 값을 변수에 저장
  String date = Get.parameters['timestamp'];
  var getLiked = Get.parameters['isLiked'].toLowerCase() == 'true';
  var getCommentsCount = int.parse(Get.parameters['commentsCount']);
  var getLikesCount = int.parse(Get.parameters['likesCount']);
  var getIndex = int.parse(Get.parameters['index']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Feather.chevron_left),
          onPressed: () {
            postController.commentList.clear(); // 코맨트리스트 초기화
            postController.commentList.refresh(); // 코맨트리스트 변화 감지
            postController.postList.refresh(); // 코맨트카운트 널값나올지
            Get.back();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Feather.bookmark),
            onPressed: () {
              print('${Get.parameters['uId']} ${Get.parameters['username']}');
            },
            color: Colors.black,
          ),
        ],
        excludeHeaderSemantics: true,
      ),
      body: GestureDetector(
        // 다른 화면을 누를시 키보드 내려감
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Stack(
          children: [
            ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 이미지가 있을경우 이미지 영
                    // Container(
                    //   child: Image.network(
                    //     Get.arguments['postImageURL'],
                    //     width: Get.width,
                    //     fit: BoxFit.fitHeight,
                    //   ),
                    // ),
                    /// 포스트 본문
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 30, left: 24, right: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(Get.parameters['postTitle'],
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text(
                            Get.parameters['username'],
                            style: TextStyle(color: Colors.blue),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(Get.parameters['timestamp'],
                                  style: TextStyle(color: Color(0xFF888888))),
                              Obx(() {
                                return Row(
                                  children: [
                                    Text(
                                        '좋아요 ${postController.likesCount.value}',
                                        style: TextStyle(
                                            color: Color(0xFF888888))),
                                    SizedBox(width: 5),
                                    Text(
                                        '댓글 ${postController.commentsCount.value}',
                                        style: TextStyle(
                                            color: Color(0xFF888888))),
                                  ],
                                );
                              }),
                            ],
                          ),
                          SizedBox(height: 10),
                          Divider(
                            height: 0,
                          ),
                          SizedBox(height: 20),
                          Text(
                            Get.parameters['postDescription'],
                            style: TextStyle(
                                fontSize: 20, color: Colors.black, height: 1.5),
                          ),
                          SizedBox(height: 30),

                          /// 좋아요 버튼
                          GestureDetector(
                            onTap: () {
                              if (!postController.isLiked.value) {
                                communityRef
                                    .doc(Get.parameters['postId'])
                                    .update({
                                  'likes.${authController.firebaseUser.uid}':
                                      authController.firebaseUser.uid
                                });

                                communityRef
                                    .doc(Get.parameters['postId'])
                                    .update(
                                        {'countLike': FieldValue.increment(1)});
                                postController.likesCount.value++;
                                postController.isLiked.value = true;
                                postController.postList[getIndex]['likes']
                                        ['${authController.firebaseUser.uid}'] =
                                    authController.firebaseUser.uid;
                                postController.postList[getIndex]
                                    ['countLike']++;
                                print('포스트 좋아요');
                              } else {
                                communityRef
                                    .doc(Get.parameters['postId'])
                                    .update({
                                  'likes.${authController.firebaseUser.uid}':
                                      FieldValue.delete()
                                });

                                communityRef
                                    .doc(Get.parameters['postId'])
                                    .update({
                                  'countLike': FieldValue.increment(-1)
                                }); //
                                postController.likesCount.value--;
                                //
                                postController.isLiked.value = false;
                                // 포스트의 좋아요 null 값
                                postController.postList[getIndex]['likes']
                                        ['${authController.firebaseUser.uid}'] =
                                    null;
                                // 포스트의 좋아요 감소
                                postController.postList[getIndex]
                                    ['countLike']--;
                                print('포스트 좋아요 취소');
                              }
                            },
                            child: Center(
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(100),
                                    ),
                                    color: postController.isLiked.value == true
                                        ? Colors.blue
                                        : Colors.white),
                                child: Icon(
                                  Feather.thumbs_up,
                                  color: postController.isLiked.value == true
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 20),
                        ],
                      ),
                    ),

                    /// 답글을 남길 경우 보이는 화면
                    reCommenting == true
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 10),
                            child: Container(
                              child: Row(
                                children: [
                                  Text('000님에게 댓글 남기는중...'),
                                  RaisedButton(
                                    onPressed: () {
                                      setState(() {
                                        reCommenting = false;
                                      });
                                    },
                                    child: Icon(Feather.x),
                                  )
                                ],
                              ),
                            ),
                          )
                        : SizedBox(height: 0),

                    /// 댓글 입력
                    Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.fromBorderSide(
                              BorderSide(width: 1, color: Colors.blue),
                            ),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5)),
                          ),
                          width: Get.width - 100,
                          height: 60,
                          child: TextField(
                            keyboardAppearance: Brightness.light,
                            controller: commentController,
                            // onSubmitted: _handleSubmitted,
                            decoration: new InputDecoration.collapsed(
                                hintText: "댓글을 입력해주세요"),
                            maxLines: null,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              // border:
                              //     Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(5)),
                              color: Colors.blue),
                          width: 60,
                          height: 60,
                          margin: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: IconButton(
                              icon: Icon(Feather.send),
                              color: Colors.white,
                              onPressed: () {
                                /// 댓글을 다는 경우
                                reCommenting == false
                                    ? dataController.addComment(
                                        Get.parameters['postId'],
                                        commentId,
                                        commentController.text)
                                    :

                                    /// 답글을 다는 경우
                                    dataController.addReComment(
                                        Get.parameters['postId'],
                                        getCommentId,
                                        commentController.text,
                                        reCommentId);

                                // 커뮤니티 포스트 안에 댓글 카운트 증가
                                dataController.incrementCountCommentInCommunity(
                                    Get.parameters['postId']);

                                // 알람을 위해 userSide comments에 값을 추가
                                dataController.addCommentInUser(
                                    Get.parameters['uId'],
                                    Get.parameters['postId'],
                                    Get.parameters['postTitle'],
                                    commentId,
                                    commentController.text,
                                    choiceCategory);
                                // 유저의 포스트 정보에 댓글 카운트를 증
                                dataController.incrementCountCommentInUser(
                                    Get.parameters['uId'],
                                    Get.parameters['postId']);

                                /// 포스트 게시한 유저가 볼 알람이 있나 업데이트 해줌
                                Get.parameters['uId'] !=
                                        userController.usermodel.value.uId
                                    ? usersRef
                                        .doc(Get.parameters['uId'])
                                        .update({'haveNotification': true})
                                    : null;

                                /// 유저컨트롤러 업데이

                                postController.commentsCount.value++;
                                postController.postList[getIndex]
                                        ['countComment'] =
                                    postController.commentsCount.value;
                                postController.postList.refresh();

                                clearCommentInfo();
                                FocusManager.instance.primaryFocus?.unfocus();
                                print('upload & refreshed comment');
                              }),
                        ),
                      ],
                    )),

                    /// 댓글
                    Obx(() {
                      return Container(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: postController.commentList.length,
                            itemBuilder: (context, index) => Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                color: Colors.grey[300],
                                width: 1,
                              ))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    postController.commentList[index]
                                        ['userInfo']['uNickName'],
                                    style: TextStyle(color: Colors.blueAccent),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          postController.commentList[index]
                                              ['comment'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                      ),
                                      // Row(
                                      //   children: [
                                      //     InkWell(
                                      //       onTap: () {
                                      //         setState(() {
                                      //           reCommenting = true;
                                      //           getCommentId =
                                      //               CommentSN[index]
                                      //                   ['commentId'];
                                      //           print(getCommentId);
                                      //         });
                                      //       },
                                      //       child: Icon(
                                      //         Feather.corner_down_left,
                                      //         size: 16,
                                      //       ),
                                      //     ),
                                      //   ],
                                      // )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  //
                                  // /// 대 댓글
                                  // FutureBuilder<QuerySnapshot>(
                                  //     future: communityRef
                                  //         .doc(Get.parameters['postId'])
                                  //         .collection('comments')
                                  //         .doc(CommentSN[index]
                                  //             ['commentId'])
                                  //         .collection('reComments')
                                  //         .orderBy('timestamp',
                                  //             descending: false)
                                  //         .get(),
                                  //     builder: (BuildContext context,
                                  //         AsyncSnapshot<QuerySnapshot>
                                  //             snapshot) {
                                  //       if (snapshot.connectionState ==
                                  //           ConnectionState.waiting) {
                                  //         return circularProgress();
                                  //       }
                                  //       final reCommentSN =
                                  //           snapshot.data.docs;
                                  //       final DataLength =
                                  //           snapshot.data.docs.length;
                                  //       return DataLength > 0
                                  //           ? ListView.builder(
                                  //               physics:
                                  //                   const NeverScrollableScrollPhysics(),
                                  //               shrinkWrap: true,
                                  //               itemCount: snapshot
                                  //                   .data.docs.length,
                                  //               itemBuilder:
                                  //                   (context, index) =>
                                  //                       Container(
                                  //                 decoration:
                                  //                     BoxDecoration(
                                  //                         border:
                                  //                             Border(
                                  //                                 bottom:
                                  //                                     BorderSide(
                                  //                           color: Colors
                                  //                                   .grey[
                                  //                               300],
                                  //                           width: 1,
                                  //                         )),
                                  //                         color: Colors
                                  //                                 .grey[
                                  //                             200]),
                                  //                 padding:
                                  //                     EdgeInsets.only(
                                  //                         left: 10),
                                  //                 child: Column(
                                  //                   crossAxisAlignment:
                                  //                       CrossAxisAlignment
                                  //                           .start,
                                  //                   mainAxisSize:
                                  //                       MainAxisSize
                                  //                           .min,
                                  //                   children: [
                                  //                     SizedBox(
                                  //                       height: 10,
                                  //                     ),
                                  //                     Text(
                                  //                       reCommentSN[index]
                                  //                               [
                                  //                               'userInfo']
                                  //                           [
                                  //                           'uNickName'],
                                  //                       style: TextStyle(
                                  //                           color: Colors
                                  //                               .blueAccent),
                                  //                     ),
                                  //                     Row(
                                  //                       mainAxisAlignment:
                                  //                           MainAxisAlignment
                                  //                               .spaceBetween,
                                  //                       crossAxisAlignment:
                                  //                           CrossAxisAlignment
                                  //                               .end,
                                  //                       children: [
                                  //                         Flexible(
                                  //                           child: Text(
                                  //                             reCommentSN[
                                  //                                     index]
                                  //                                 [
                                  //                                 'comment'],
                                  //                             style: TextStyle(
                                  //                                 fontSize:
                                  //                                     16,
                                  //                                 color:
                                  //                                     Colors.black),
                                  //                           ),
                                  //                         ),
                                  //                         Row(
                                  //                           children: [
                                  //                             InkWell(
                                  //                               onTap:
                                  //                                   () {
                                  //                                 setState(
                                  //                                     () {
                                  //                                   reCommenting =
                                  //                                       true;
                                  //                                   getCommentId =
                                  //                                       CommentSN[index]['commentId'];
                                  //                                   print(getCommentId);
                                  //                                 });
                                  //                               },
                                  //                               child:
                                  //                                   Icon(
                                  //                                 Feather
                                  //                                     .corner_down_left,
                                  //                                 size:
                                  //                                     16,
                                  //                               ),
                                  //                             ),
                                  //                           ],
                                  //                         )
                                  //                       ],
                                  //                     ),
                                  //                     SizedBox(
                                  //                       height: 10,
                                  //                     ),
                                  //                   ],
                                  //                 ),
                                  //               ),
                                  //             )
                                  //           : SizedBox(
                                  //               height: 0,
                                  //             );
                                  //     }),
                                ],
                              ),
                            ),
                          )
                          // : Container(
                          //     decoration: BoxDecoration(
                          //         border: Border(
                          //             bottom: BorderSide(
                          //       color: Colors.grey,
                          //       width: 1,
                          //     ))),
                          //     height: 100,
                          //     child: Center(child: Text('아직 댓글이 없어요')),
                          //   )

                          );
                    }),

                    SizedBox(height: 20),

                    // SizedBox(height: 15),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  clearCommentInfo() {
    commentId = Uuid().v4();
    reCommentId = Uuid().v4();
    commentController.clear();
  }
}
