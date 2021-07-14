import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String commentId;
  String comment;
  Timestamp timestamp;
  UserInfo userInfo;

  CommentModel({this.commentId, this.comment, this.timestamp});

  CommentModel.fromJson(Map<String, dynamic> json) {
    commentId = json['commentId'];
    comment = json['comment'];
    timestamp = json['timestamp'];
    userInfo = json['userInfo'] != null
        ? new UserInfo.fromJson(json['userInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commentId'] = this.commentId;
    data['comment'] = this.comment;
    data['timestamp'] = this.timestamp;
    if (this.userInfo != null) {
      data['userInfo'] = this.userInfo.toJson();
    }
    return data;
  }
}

class UserInfo {
  String uId;
  String uPhotoURL;
  String uNickName;

  UserInfo({this.uId, this.uPhotoURL, this.uNickName});

  UserInfo.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    uPhotoURL = json['uPhotoURL'];
    uNickName = json['uNickName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uId'] = this.uId;
    data['uPhotoURL'] = this.uPhotoURL;
    data['uNickName'] = this.uNickName;
    return data;
  }
}
