import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:neighbor_library/utilities/constants.dart';
import 'package:neighbor_library/widgets/items_view.dart';
import 'package:neighbor_library/widgets/progress_widget.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ItemScreen extends StatefulWidget {
  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '나의 아이템',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Feather.chevron_left,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: FutureBuilder<QuerySnapshot>(
            future: usersRef
                .doc(authController.firebaseUser.uid)
                .collection('items')
                .get(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return circularProgress();
              }

              /// 아이템 더보기 화면
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1,
                    crossAxisCount: 3,
                    crossAxisSpacing: 13,
                    mainAxisSpacing: 20),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(left: 0, right: 0),
                  child: new ItemsView(
                    queryDS: snapshot.data.docs[index],
                    showItems: false,
                  ),
                ),
              );
            }),
      ),
    );
  }
}
