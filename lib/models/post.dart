import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neighbor_library/utilities/constants.dart';

var currentUser = authController.firebaseUser.uid;
// class PostModel {
//   String postId;
//   String postTitle;
//
//   PostModel({this.postId, this.postTitle});
//
//   factory PostModel.fromJson(Map<String, dynamic> json) {
//     return PostModel(
//       postId: json['postId'],
//       postTitle: json['postTitle'],
//     );
//   }
//
//   factory PostModel.fromSnapshot(QuerySnapshot snapshot) {
//     Map data = snapshot.docs.asMap();
//     return PostModel(
//       postId: data['postId'],
//       postTitle: data['postTitle'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'postId': postId,
//       'postTitle': postTitle,
//     };
//   }
//   //
//   // PostModel.fromDocumentSnapshot(
//   //   DocumentSnapshot documentSnapshot,
//   // ) {
//   //   postId = documentSnapshot.id;
//   //   postTitle = documentSnapshot.get('postTitle');
//   // }
// }

class PostModel {
  String postId;
  String category;
  String postImageURL;
  UserInfo userInfo;
  String postDescription;
  Likes likes;
  int countComment;
  int countLike;
  String postTitle;
  Timestamp timestamp;

  PostModel(
      {this.postId,
      this.category,
      this.postImageURL,
      this.userInfo,
      this.postDescription,
      this.likes,
      this.countComment,
      this.countLike,
      this.postTitle,
      this.timestamp});

  PostModel.fromJson(Map<String, dynamic> json) {
    postId = json['postId'];
    category = json['category'];
    postImageURL = json['postImageURL'];
    userInfo = json['userInfo'] != null
        ? new UserInfo.fromJson(json['userInfo'])
        : null;
    postDescription = json['postDescription'];
    likes = json['likes'] != null ? new Likes.fromJson(json['likes']) : null;
    countComment = json['countComment'];
    countLike = json['countLike'];
    postTitle = json['postTitle'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postId'] = this.postId;
    data['category'] = this.category;
    data['postImageURL'] = this.postImageURL;
    if (this.userInfo != null) {
      data['userInfo'] = this.userInfo.toJson();
    }
    data['postDescription'] = this.postDescription;
    if (this.likes != null) {
      data['likes'] = this.likes.toJson();
    }
    data['countComment'] = this.countComment;
    data['countLike'] = this.countLike;
    data['postTitle'] = this.postTitle;
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class UserInfo {
  String uId;
  String photoURL;
  String username;

  UserInfo({this.uId, this.photoURL, this.username});

  UserInfo.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    photoURL = json['PhotoURL'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uId'] = this.uId;
    data['PhotoURL'] = this.photoURL;
    data['username'] = this.username;
    return data;
  }
}

class Likes {
  String uId;

  Likes({this.uId});

  Likes.fromJson(Map<String, dynamic> json) {
    uId = json[currentUser]; // 값에 해당하는 부분
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[currentUser] = this.uId; // 필드명에 해당하는 부분
    return data;
  }
}
