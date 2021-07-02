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

  String date = Get.parameters['timestamp'];

  int DD = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: Icon(Feather.chevron_left),
      //     onPressed: () {
      //       Get.back();
      //     },
      //     color: Colors.black,
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Feather.bookmark),
      //       onPressed: () {
      //         print('bookmark');
      //       },
      //       color: Colors.black,
      //     ),
      //   ],
      //   excludeHeaderSemantics: true,
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      // ),
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
                            style: TextStyle(color: Color(0xFF888888)),
                          ),
                          SizedBox(height: 10),
                          Text(Get.parameters['timestamp'],
                              style: TextStyle(color: Color(0xFF888888))),
                          SizedBox(height: 10),
                          Divider(
                            height: 0,
                          ),
                          SizedBox(height: 40),
                          Text(
                            Get.parameters['postDescription'],
                            style: TextStyle(
                                fontSize: 20, color: Colors.black, height: 1.5),
                          ),
                          SizedBox(height: 40),
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

                    /// 댓글
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: FutureBuilder<QuerySnapshot>(
                          future: communityRef
                              .doc(Get.parameters['choiceCategory'])
                              .collection('posts')
                              .doc(Get.parameters['postId'])
                              .collection('comment')
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
                                    itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 5),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                CommentSN[index]['userInfo']
                                                    ['username'],
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              SizedBox(width: 10),
                                              Flexible(
                                                child: Text(
                                                  CommentSN[index]['comment'],
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Divider(
                                            height: 1,
                                            color: Color(0xff888888),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 100,
                                    child: Center(child: Text('아직 댓글이 없어요')),
                                  );
                          }),
                    ),

                    /// 댓글 입력
                    Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.fromBorderSide(
                                  BorderSide(width: 1, color: Colors.grey),
                                ),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5)),
                              ),
                              width: Get.width - 100,
                              height: 50,
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
                              width: 50,
                              height: 50,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              child: IconButton(
                                  icon: Icon(Feather.send),
                                  color: Colors.white,
                                  onPressed: () {
                                    communityRef
                                        .doc(Get.parameters['choiceCategory'])
                                        .collection('posts')
                                        .doc(Get.parameters['postId'])
                                        .collection('comment')
                                        .doc(commentId)
                                        .set({
                                      'commentId': commentId,
                                      'comment': commentController.text,
                                      'timestamp': Timestamp.now(),
                                      'userInfo': {
                                        'photoURL': authController
                                            .firebaseUser.photoURL,
                                        'uId': authController.firebaseUser.uid,
                                        'username':
                                            userController.user.value.username,
                                      }
                                    }); // commentId로 생성한 doc에 값 추가
                                    // postsRef
                                    //     .doc(Get.parameters['postId'])
                                    //     .update({
                                    //   'counts.commentsCount':
                                    //       FieldValue.increment(1)
                                    // }); // 댓글카운트 증가
                                    clearCommentInfo();
                                    // Navigator.pushReplacement(
                                    //     context,
                                    //     PageRouteBuilder(
                                    //         pageBuilder: (a, b, c) => CommentScreen(),
                                    //         transitionDuration: Duration(seconds: 0)));
                                    // Get.off(RefreshTest(), duration: Duration(seconds: 0));
                                    // setState(() {
                                    //   commentCount++; // engagement_bar로 반환해줄 값을 변화 시킴
                                    // });
                                    print('refreshed comment');
                                  }),
                            ),
                          ],
                        )),
                    SizedBox(height: 15),

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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: ButtonTheme(
                              buttonColor: Colors.grey[200],
                              minWidth: Get.width / 1.8,
                              height: 56,
                              child: RaisedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Icon(
                                        Feather.chevron_left,
                                        color: Colors.grey[600],
                                        size: 30,
                                      ),
                                    ),
                                    Text(
                                      '나가기',
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(width: 20)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.amber, width: 1)),
                          )
                        ],
                      ),
                    ),
                  ),
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
    commentController.clear();
  }
}
