import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:neighbor_library/utilities/constants.dart';
import 'package:neighbor_library/widgets/items_view.dart';
import 'package:neighbor_library/widgets/progress_widget.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UserGetItemsScreen extends StatefulWidget {
  @override
  _UserGetItemsScreenState createState() => _UserGetItemsScreenState();
}

class _UserGetItemsScreenState extends State<UserGetItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Get.arguments['snapshotIndex']['name'].toString().toUpperCase(),
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
                .doc(Get.arguments['snapshotIndex']['name'])
                .collection('itemList')
                .get(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return circularProgress();
              }
              if (snapshot.connectionState == ConnectionState.done) {
                print(snapshot.isBlank);
              }
              // 유저의 아이템이 있는지 체크
              return Get.arguments['snapshotIndex']['count'] >= 1
                  ? GridView.builder(
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
                            showItems: true,
                          )),
                    )

                  /// 유저가 등록한 아이템이 없다면 등록 화면을 보여줌
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '이런! 아직 등록된 아이템이 없어요',
                            style: TextStyle(fontSize: 20),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 20, right: 20, bottom: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ButtonTheme(
                                minWidth: Get.width,
                                buttonColor: Colors.blue[500],
                                height: 56,
                                child: RaisedButton(
                                  onPressed: () {
                                    // Get.to(UploadMystyleScreen());
                                  },
                                  child: Text(
                                    '아이템 등록하기',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
            }),
      ),
    );
  }
}
