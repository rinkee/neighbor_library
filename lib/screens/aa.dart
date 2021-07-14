import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:neighbor_library/models/post.dart';
import 'package:neighbor_library/screens/active_screen.dart';
import 'package:neighbor_library/screens/bb.dart';
import 'package:neighbor_library/screens/upload_community_post_screen.dart';
import 'package:neighbor_library/services/controller/post_controller.dart';
import 'package:neighbor_library/utilities/constants.dart';
import 'package:neighbor_library/widgets/progress_widget.dart';
import 'package:http/http.dart' as http;

class aa extends StatelessWidget {
  final PC = Get.put(PostController());
  // List<PostModel> _postList = List<PostModel>[];
  var postList = [].obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            RaisedButton(
              onPressed: () {
                PC.lookPostList.add({'postId': 'aaa', 'postTitle': 'aaa'});
                PC.update();
              },
              child: Text('update List'),
            ),
            Container(
              height: Get.height,
              child: Expanded(
                child: Obx(() {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: PC.lookPostList
                          .where((i) => i['countComment'] == 10)
                          .length,
                      itemBuilder: (context, index) => Column(
                            children: [
                              Text(
                                  '${PC.lookPostList[index].where((i) => i['countComment'] == 10)['postId']}'),
                              RaisedButton(
                                onPressed: () {
                                  PC.lookPostList
                                      .where((i) => i['countComment'] == 10)
                                      .toList();
                                  PC.lookPostList.refresh();
                                  print(PC.lookPostList
                                      .where((i) => i['countComment'] == 10)
                                      .toList());
                                },
                                child: Text('update List'),
                              ),
                            ],
                          ));
                }),
              ),
            ),
          ],
        ),
      ),
      // body: FutureBuilder<QuerySnapshot>(
      //   future: communityRef.get(),
      //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return circularProgress();
      //     }
      //
      //     // print(snapshot.data.docs.length);
      //     // for (int i = 0; i < snapshot.data.docs.length; i++) {
      //     //   postList
      //     //       .add(PostModel.fromJson(snapshot.data.docs[i].data()).toJson());
      //     // }
      //     // // postList.add(snapshot.data.docs[0].data());
      //     // // postList.value = _postList;
      //     // print(postList.toList());
      //     return Column(
      //       children: [
      //         RaisedButton(
      //           onPressed: () {
      //             postList.value.clear();
      //             postList.refresh();
      //           },
      //           child: Text('data clear'),
      //         ),
      //         Obx(() => Expanded(
      //               child: ListView.builder(
      //                   itemCount: 2,
      //                   itemBuilder: (context, index) => Column(
      //                         children: [
      //                           // Text('${postList}'),
      //                           Text('${PC.commentCount}'),
      //                           Text('aa'),
      //                           RaisedButton(
      //                             onPressed: () {
      //                               PC.commentCount[index]['postId'] =
      //                                   'abc'.obs;
      //                               // print(postList[index]['postId']);
      //                             },
      //                             child: Text('data chanege'),
      //                           ),
      //                           RaisedButton(
      //                             onPressed: () {
      //                               PC.fetchPost();
      //                             },
      //                             child: Text('data fetchPost'),
      //                           ),
      //                         ],
      //                       )),
      //             ))
      //       ],
      //     );
      //   },
      // ),a
    );
  }
}
