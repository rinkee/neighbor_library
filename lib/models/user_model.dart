import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const ID = "uId";

  String uId;
  String uPhotoURL;
  String uProfileName;
  String uNickName;
  String uEmail;
  int gender;
  int postCount;
  bool haveColor;
  bool haveItem;
  bool haveNotification;
  Timestamp createAccountDate;
  Timestamp lastUploadBuy;
  Timestamp lastUploadLook;

  UserModel(
      {this.uId,
      this.uPhotoURL,
      this.uProfileName,
      this.uNickName,
      this.uEmail,
      this.gender,
      this.postCount,
      this.haveColor,
      this.haveItem,
      this.haveNotification,
      this.createAccountDate,
      this.lastUploadBuy,
      this.lastUploadLook});

  UserModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    uPhotoURL = json['uPhotoURL'];
    uProfileName = json['uProfileName'];
    uNickName = json['uNickName'];
    uEmail = json['uEmail'];
    gender = json['gender'];
    postCount = json['postCount'];
    haveColor = json['haveColor'];
    haveItem = json['haveItem'];
    haveNotification = json['haveNotification'];
    createAccountDate = json['createAccountDate'];
    lastUploadBuy = json['lastUploadBuy'];
    lastUploadLook = json['lastUploadLook'];
  }

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    uId = snapshot.get('uId');
    uPhotoURL = snapshot.get('uPhotoURL');
    uProfileName = snapshot.get('uProfileName');
    uNickName = snapshot.get('uNickName');
    uEmail = snapshot.get('uEmail');
    gender = snapshot.get('gender');
    postCount = snapshot.get('postCount');
    haveColor = snapshot.get('haveColor');
    haveItem = snapshot.get('haveItem');
    haveNotification = snapshot.get('haveNotification');
    createAccountDate = snapshot.get('createAccountDate');
    lastUploadBuy = snapshot.get('lastUploadBuy');
    lastUploadLook = snapshot.get('lastUploadLook');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uId'] = this.uId;
    data['uPhotoURL'] = this.uPhotoURL;
    data['uProfileName'] = this.uProfileName;
    data['uNickName'] = this.uNickName;
    data['uEmail'] = this.uEmail;
    data['gender'] = this.gender;
    data['postCount'] = this.postCount;
    data['haveColor'] = this.haveColor;
    data['haveItem'] = this.haveItem;
    data['haveNotification'] = this.haveNotification;
    data['createAccountDate'] = this.createAccountDate;
    data['lastUploadBuy'] = this.lastUploadBuy;
    data['lastUploadLook'] = this.lastUploadLook;
    return data;
  }
}
