import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neighbor_library/models/post.dart';
import 'package:neighbor_library/utilities/constants.dart';

class DataController extends GetxController {
  Future<void> addComment(
    String postId,
    String commentId,
    String comment,
  ) async {
    try {
      await communityRef.doc(postId).collection('comments').doc(commentId).set({
        'commentId': commentId,
        'comment': comment,
        'timestamp': Timestamp.now(),
        'userInfo': {
          'uPhotoURL': authController.firebaseUser.photoURL,
          'uId': authController.firebaseUser.uid,
          'uNickName': userController.usermodel.value.uNickName,
        }
      });
      postController.commentList.clear();
      postController.fetchCommentOneList(postId);
      postController.commentList.refresh();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> addReComment(
    String postId,
    String getCommentId,
    String comment,
    String reCommentId,
  ) async {
    try {
      await communityRef
          .doc(postId)
          .collection('comments')
          .doc(getCommentId)
          .collection('reComments')
          .doc(reCommentId)
          .set({
        'commentId': reCommentId,
        'comment': comment,
        'timestamp': Timestamp.now(),
        'userInfo': {
          'uPhotoURL': authController.firebaseUser.photoURL,
          'uId': authController.firebaseUser.uid,
          'uNickName': userController.usermodel.value.uNickName
        }
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> addCommentInUser(
    String uId,
    String postId,
    String postTitle,
    String commentId,
    String comment,
    String choiceCategory,
  ) async {
    try {
      await usersRef.doc(uId).collection('comments').doc(commentId).set({
        'category': choiceCategory,
        'isDeletedNotification': false,
        'postId': postId,
        'postTitle': postTitle,
        'commentId': commentId,
        'comment': comment,
        'timestamp': Timestamp.now(),
        'userInfo': {
          'uPhotoURL': authController.firebaseUser.photoURL,
          'uId': authController.firebaseUser.uid,
          'uNickName': userController.usermodel.value.uNickName,
        }
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> incrementCountCommentInUser(
    String uId,
    String postId,
  ) async {
    try {
      await usersRef
          .doc(uId)
          .collection('comments')
          .doc(postId)
          .update({'countComment': FieldValue.increment(1)});
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> incrementCountCommentInCommunity(
    String postId,
  ) async {
    try {
      await communityRef
          .doc(postId)
          .update({'countComment': FieldValue.increment(1)});
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
