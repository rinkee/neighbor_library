import 'package:flutter/material.dart';
// controller
import 'package:neighbor_library/utilities/constants.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LoginPage'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              RaisedButton(
                onPressed: () {
                  authController.signInWithGoogle();
                },
                child: Text('google Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
