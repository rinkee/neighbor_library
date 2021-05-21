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
          Text(userController.user.value.username),
          RaisedButton(
            onPressed: () {
              authController.signOut();
            },
            child: Text('로그아'),
          ),
        ],
      ),
    );
  }
}
