import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neighbor_library/utilities/constants.dart';
import 'package:neighbor_library/widgets/progress_widget.dart';

class MyPostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '나의 코디',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<QuerySnapshot>(
          future: postsRef
              .where('userInfo.uId', isEqualTo: authController.firebaseUser.uid)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return circularProgress();
            }

            return new GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.55),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) => Container(
                // decoration:
                //     BoxDecoration(border: Border.all(color: Colors.red)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      snapshot.data.docs[index]['postImageURL'],
                      width: Get.width * 2,
                      height: Get.height * 0.35,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      snapshot.data.docs[index]['postTitle'].toString(),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      snapshot.data.docs[index]['postTitle'].toString(),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
