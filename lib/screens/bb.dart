import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neighbor_library/utilities/constants.dart';

class bb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('page b'),
      ),
      body: Column(
        children: [
          RaisedButton(
            onPressed: () {
              usersRef
                  .doc(authController.firebaseUser.uid)
                  .update({'isSeemed': true});
            },
            child: Text('change is seemed TRUE'),
          ),
          RaisedButton(
            onPressed: () {
              usersRef
                  .doc(authController.firebaseUser.uid)
                  .update({'isSeemed': false});
            },
            child: Text('change is seemed False'),
          ),
        ],
      ),
    );
  }
}
