import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neighbor_library/utilities/constants.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('userpage'),
      ),
      body: Column(
        children: [
          Text(authController.firebaseUser.displayName),
          Text(userController.user.value.username),

          /// firestore에서 값을 불러오면 바로바로 변화가 반영
          RaisedButton(
            onPressed: () {
              authController.signOut();
            },
            child: Text('로그아'),
          ),
          RaisedButton(
            onPressed: () {
              print(usersRef
                  .doc(authController.firebaseUser.uid)
                  .get()
                  .then((DocumentSnapshot documentSnapshot) {
                if (documentSnapshot.exists) {
                  userController.change(
                      id: authController.firebaseUser.uid,
                      username: documentSnapshot['username']);

                  print(userController.user.value.username);
                }
              }));
            },
            child: Text('test'),
          ),
        ],
      ),
    );
  }
}
