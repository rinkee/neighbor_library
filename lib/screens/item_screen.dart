import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neighbor_library/utilities/constants.dart';
import 'package:neighbor_library/widgets/progress_widget.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

final url = firebase_storage.FirebaseStorage.instance
    .refFromURL('gs://neighbor-library-a01d4.appspot.com/icons/cap.png')
    .child(path);

class ItemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '나의 아이템',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<QuerySnapshot>(
          future: usersRef
              .doc(authController.firebaseUser.uid)
              .collection('items')
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return circularProgress();
            }

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 0.55),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) => new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image.network(
                  //   snapshot.data.docs[index]['postImageURL'],
                  //   width: Get.width,
                  //   height: Get.width * 0.6,
                  //   fit: BoxFit.cover,
                  // ),
                  Image.network(),
                  Text(
                    snapshot.data.docs[index]['name'].toString(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    snapshot.data.docs[index]['count'].toString(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
