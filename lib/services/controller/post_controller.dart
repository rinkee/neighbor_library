import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:neighbor_library/models/comment_model.dart';
import 'package:neighbor_library/models/post.dart';
import 'package:neighbor_library/models/post.dart';
import 'package:neighbor_library/services/controller/database.dart';
import 'package:neighbor_library/services/controller/screen_controller.dart';
import 'package:neighbor_library/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class PostController extends GetxController {
  // 포스트 & 댓글을 담는 리스트
  var lookPostList = [].obs;
  var buyPostList = [].obs;
  var postList = [].obs;
  var commentList = [].obs;

  // 상황 변화에 이용
  var isLiked = false.obs;
  var commentsCount = 0.obs;
  var likesCount = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchPostOneList('코디고민');
  }

  //패치해서 나눠서 저장
  void fetchPost(String categoryName, List list) async {
    await communityRef
        .where('category', isEqualTo: categoryName)
        .orderBy('timestamp', descending: true)
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        list.add(PostModel.fromJson(value.docs[i].data()).toJson());
      }
      print(list);
    });
  }

  // 패치해서 한곳에 저장
  void fetchPostOneList(String categoryName) async {
    await communityRef
        .where('category', isEqualTo: categoryName)
        .orderBy('timestamp', descending: true)
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        postList.add(PostModel.fromJson(value.docs[i].data()).toJson());
      }
      print(postList);
    });
  }

  void fetchCommentOneList(String postId) async {
    await communityRef
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        commentList.add(CommentModel.fromJson(value.docs[i].data()).toJson());
      }
      print(commentList);
    });
  }
}
