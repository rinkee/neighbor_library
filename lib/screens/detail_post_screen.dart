import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
//func
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
//screen
import 'package:neighbor_library/screens/community_screen.dart';
import 'package:neighbor_library/screens/home_screen.dart';
import 'package:neighbor_library/utilities/constants.dart';
import 'package:neighbor_library/widgets/progress_widget.dart';

class DetailPostScreen extends StatefulWidget {
  @override
  _DetailPostScreenState createState() => _DetailPostScreenState();
}

class _DetailPostScreenState extends State<DetailPostScreen> {
  TextEditingController commentController = TextEditingController();

  String commentId = Uuid().v4();
  String reCommentId = Uuid().v4();

  String date = Get.parameters['timestamp'];
  bool isLiked = Get.parameters['isLiked'] == 'true';

  bool reCommenting = false;
  String getCommentId;

  var commentsCount = int.parse(Get.parameters['commentsCount']);
  var likesCount = int.parse(Get.parameters['likesCount']);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Feather.chevron_left),
          onPressed: () {
            Get.back(result: isLiked);
          },
          color: Colors.black,
        ),
        actions: [
          IconButton(
            icon: Icon(Feather.bookmark),
            onPressed: () {
              print('${Get.parameters['uId']} ${Get.parameters['username']}');
              print('접속한 유저 ${userController.user.value.id}');
            },
            color: Colors.black,
          ),
        ],
        excludeHeaderSemantics: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Stack(
          children: [
            ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                              Row(
                                children: [
                                  Text('좋아요 ${likesCount}',
                                      style:
                                          TextStyle(color: Color(0xFF888888))),
                                  SizedBox(width: 5),
                                  Text('댓글 ${commentsCount}',
                                      style:
                                          TextStyle(color: Color(0xFF888888)))
                                ],
                              ),
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
                              if (!isLiked) {
                                communityRef
                                    .doc(Get.parameters['postId'])
                                    .update({
                                  'likes.${authController.firebaseUser.uid}':
                                      authController.firebaseUser.uid
                                });

                                communityRef
                                    .doc(Get.parameters['postId'])
                                    .update({
                                  'counts.likesCount': FieldValue.increment(1)
                                });
                                setState(() {
                                  isLiked = true;
                                  likesCount++;
                                });
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
                                  'counts.likesCount': FieldValue.increment(-1)
                                }); //
                                setState(() {
                                  isLiked = false;
                                  likesCount--;
                                });
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
                                    color: isLiked == true
                                        ? Colors.blue
                                        : Colors.white),
                                child: Icon(
                                  Feather.thumbs_up,
                                  color: isLiked == true
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
                    SizedBox(
                      height: 10,
                      child: Container(
                        color: Colors.grey[100],
                      ),
                    ),
                    SizedBox(height: 10),

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
                                ///

                                reCommenting == false

                                    /// 그냥 댓글을 다는 경
                                    ? communityRef // commentId로 생성한 doc에 값 추가
                                        .doc(Get.parameters['postId'])
                                        .collection('comments')
                                        .doc(commentId)
                                        .set({
                                        'commentId': commentId,
                                        'comment': commentController.text,
                                        'timestamp': Timestamp.now(),
                                        'userInfo': {
                                          'photoURL': authController
                                              .firebaseUser.photoURL,
                                          'uId':
                                              authController.firebaseUser.uid,
                                          'username': userController
                                              .user.value.username,
                                        }
                                      })

                                    /// 답글을 다는 경우
                                    : communityRef // commentId로 생성한 doc에 값 추가
                                        .doc(Get.parameters['postId'])
                                        .collection('comments')
                                        .doc(getCommentId)
                                        .collection('reComments')
                                        .doc(reCommentId)
                                        .set({
                                        'commentId': reCommentId,
                                        'comment': commentController.text,
                                        'timestamp': Timestamp.now(),
                                        'userInfo': {
                                          'photoURL': authController
                                              .firebaseUser.photoURL,
                                          'uId':
                                              authController.firebaseUser.uid,
                                          'username': userController
                                              .user.value.username,
                                        }
                                      });

                                communityRef // 댓글카운트 증가
                                    .doc(Get.parameters['postId'])
                                    .update({
                                  'counts.commentsCount':
                                      FieldValue.increment(1)
                                });

                                /// 알람을 위해 userSide comments에 값을 추가
                                usersRef
                                    .doc(Get.parameters['uId'])
                                    .collection('comments')
                                    .doc(commentId)
                                    .set({
                                  'category': choiceCategory,
                                  'isDeletedNotification': false,
                                  'postId': Get.parameters['postId'],
                                  'postTitle': Get.parameters['postTitle'],
                                  'commentId': commentId,
                                  'comment': commentController.text,
                                  'timestamp': Timestamp.now(),
                                  'userInfo': {
                                    'photoURL':
                                        authController.firebaseUser.photoURL,
                                    'uId': authController.firebaseUser.uid,
                                    'username':
                                        userController.user.value.username,
                                  }
                                }); // commentId로 생성한 doc에 값 추가
                                usersRef
                                    .doc(Get.parameters['uId'])
                                    .collection('community')
                                    .doc(Get.parameters['postId'])
                                    .update({
                                  'counts.commentsCount':
                                      FieldValue.increment(1)
                                });

                                /// 유저가 볼 알람이 있ek fkrh 업데이트 해줌
                                usersRef
                                    .doc(Get.parameters['uId'])
                                    .update({'isSeemed': true});

                                /// 유저컨트롤러 업데이

                                setState(() {
                                  commentsCount++; // engagement_bar로 반환해줄 값을 변화 시킴
                                });
                                clearCommentInfo();
                                FocusManager.instance.primaryFocus?.unfocus();
                                print('upload & refreshed comment');
                              }),
                        ),
                      ],
                    )),

                    /// 댓글
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: FutureBuilder<QuerySnapshot>(
                          future: communityRef
                              .doc(Get.parameters['postId'])
                              .collection('comments')
                              .orderBy('timestamp', descending: false)
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return circularProgress();
                            }
                            final CommentSN = snapshot.data.docs;
                            final DataLength = snapshot.data.docs.length;
                            return DataLength > 0
                                ? ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (context, index) => Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                        color: Colors.grey[300],
                                        width: 1,
                                      ))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            CommentSN[index]['userInfo']
                                                ['username'],
                                            style: TextStyle(
                                                color: Colors.blueAccent),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  CommentSN[index]['comment'],
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        reCommenting = true;
                                                        getCommentId =
                                                            CommentSN[index]
                                                                ['commentId'];
                                                        print(getCommentId);
                                                      });
                                                    },
                                                    child: Icon(
                                                      Feather.corner_down_left,
                                                      size: 16,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),

                                          /// 대 댓글
                                          FutureBuilder<QuerySnapshot>(
                                              future: communityRef
                                                  .doc(Get.parameters['postId'])
                                                  .collection('comments')
                                                  .doc(CommentSN[index]
                                                      ['commentId'])
                                                  .collection('reComments')
                                                  .orderBy('timestamp',
                                                      descending: false)
                                                  .get(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return circularProgress();
                                                }
                                                final reCommentSN =
                                                    snapshot.data.docs;
                                                final DataLength =
                                                    snapshot.data.docs.length;
                                                return DataLength > 0
                                                    ? ListView.builder(
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount: snapshot
                                                            .data.docs.length,
                                                        itemBuilder:
                                                            (context, index) =>
                                                                Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  border:
                                                                      Border(
                                                                          bottom:
                                                                              BorderSide(
                                                                    color: Colors
                                                                            .grey[
                                                                        300],
                                                                    width: 1,
                                                                  )),
                                                                  color: Colors
                                                                          .grey[
                                                                      200]),
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                reCommentSN[index]
                                                                        [
                                                                        'userInfo']
                                                                    [
                                                                    'username'],
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blueAccent),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Flexible(
                                                                    child: Text(
                                                                      reCommentSN[
                                                                              index]
                                                                          [
                                                                          'comment'],
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            reCommenting =
                                                                                true;
                                                                            getCommentId =
                                                                                CommentSN[index]['commentId'];
                                                                            print(getCommentId);
                                                                          });
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          Feather
                                                                              .corner_down_left,
                                                                          size:
                                                                              16,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox(
                                                        height: 0,
                                                      );
                                              }),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ))),
                                    height: 100,
                                    child: Center(child: Text('아직 댓글이 없어요')),
                                  );
                          }),
                    ),
                    SizedBox(height: 20),

                    // SizedBox(height: 15),

                    /// Post List
                    // Column(
                    //   children: [
                    //     Container(
                    //       width: Get.width,
                    //       padding:
                    //           EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                    //       color: Colors.grey[200],
                    //       child: Text(
                    //         Get.parameters['choiceCategory'],
                    //         style: TextStyle(
                    //           fontSize: 24,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ),
                    //     Container(
                    //       padding:
                    //           EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    //       height: 210,
                    //       child: FutureBuilder<QuerySnapshot>(
                    //           future: communityRef
                    //               .doc(Get.parameters['choiceCategory'])
                    //               .collection('posts')
                    //               .get(),
                    //           builder: (BuildContext context,
                    //               AsyncSnapshot<QuerySnapshot> snapshot) {
                    //             if (snapshot.connectionState ==
                    //                 ConnectionState.waiting) {
                    //               return circularProgress();
                    //             }
                    //             final PostSN = snapshot.data.docs;
                    //             return ListView.builder(
                    //               physics: const NeverScrollableScrollPhysics(),
                    //               itemCount: PostSN.length,
                    //               itemBuilder: (context, index) => Padding(
                    //                 padding: const EdgeInsets.symmetric(
                    //                     horizontal: 0, vertical: 5),
                    //                 child: InkWell(
                    //                   onTap: () {
                    //                     Get.toNamed(
                    //                         "/DetailPostScreen?choiceCategory=${Get.parameters['choiceCategory']}&postId=${PostSN[index]['postId']}&postTitle=${PostSN[index]['postTitle']}&username=${PostSN[index]['userInfo']['username']}&postDescription=${PostSN[index]['postDescription']}");
                    //                   },
                    //                   child: Container(
                    //                     child: Column(
                    //                       crossAxisAlignment:
                    //                           CrossAxisAlignment.start,
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.center,
                    //                       children: [
                    //                         Text(
                    //                           PostSN[index]['postTitle'],
                    //                           style: TextStyle(
                    //                               fontSize: 18,
                    //                               color: Colors.black),
                    //                         ),
                    //                         SizedBox(height: 3),
                    //                         Text(
                    //                           PostSN[index]['userInfo']['username'],
                    //                           style: TextStyle(
                    //                               color: Color(0xFF888888)),
                    //                         ),
                    //                         Divider(
                    //                           color: Color(0xff888888),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             );
                    //           }),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),

                /// 나가기 버튼을 만들어볼까?
                // Container(
                //   child: Padding(
                //     padding: const EdgeInsets.only(
                //       top: 7,
                //       left: 20,
                //       right: 24,
                //       bottom: 20,
                //     ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         ClipRRect(
                //           borderRadius: BorderRadius.circular(5),
                //           child: ButtonTheme(
                //             buttonColor: Colors.white,
                //             minWidth: Get.width / 2.2,
                //             height: 56,
                //             child: RaisedButton(
                //               onPressed: () {
                //                 Get.back(result: isLiked);
                //               },
                //               child: Row(
                //                 crossAxisAlignment: CrossAxisAlignment.center,
                //                 children: [
                //                   Padding(
                //                     padding: const EdgeInsets.only(bottom: 5),
                //                     child: Icon(
                //                       Feather.chevron_left,
                //                       color: Colors.grey[600],
                //                       size: 30,
                //                     ),
                //                   ),
                //                   Text(
                //                     '나가기',
                //                     style: TextStyle(
                //                       fontSize: 22,
                //                       color: Colors.grey[600],
                //                     ),
                //                   ),
                //                   SizedBox(width: 20)
                //                 ],
                //               ),
                //             ),
                //           ),
                //         ),
                //         Container(
                //           width: 56,
                //           height: 56,
                //           decoration: BoxDecoration(
                //               border:
                //                   Border.all(color: Colors.amber, width: 1)),
                //         )
                //       ],
                //     ),
                //   ),
                // ),
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
