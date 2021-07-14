import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neighbor_library/utilities/constants.dart';
import 'package:neighbor_library/widgets/progress_widget.dart';

class ActiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Active',
          style: GoogleFonts.montserrat(
              fontSize: kMenuFontSize,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Feather.chevron_left),
          onPressed: () {
            Get.back();
          },
          color: Colors.black,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              /// 모든 알림 안보이게 바꾸기
              onTap: () async {
                var collection = usersRef
                    .doc(authController.firebaseUser.uid)
                    .collection('comments');
                var querySnapshots = await collection.get();
                for (var doc in querySnapshots.docs) {
                  await doc.reference.update({
                    'isDeletedNotification': true,
                  }); // 모든 isDeletedNotification를 트루로 변경

                }
              },
              child: Center(
                child: Text(
                  '모두 지우기',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red[600]),
                ),
              ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: FutureBuilder<QuerySnapshot>(
            future: usersRef
                .doc(authController.firebaseUser.uid)
                .collection('comments')
                .where('isDeletedNotification', isEqualTo: false)
                .orderBy('timestamp', descending: true)
                .get(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return circularProgress();
              }
              final CommentSN = snapshot.data.docs;
              final DataLength = snapshot.data.docs.length;
              return DataLength > 0
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) => Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: Colors.grey[300],
                          width: 1,
                        ))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${CommentSN[index]['postTitle']}글의 댓글입니다.',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              CommentSN[index]['userInfo']['uNickName'],
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                            SizedBox(height: 3),
                            Flexible(
                              child: Text(
                                CommentSN[index]['comment'],
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      height: 100,
                      child: Center(child: Text('알람이 없어요')),
                    );
            }),
      ),
    );
  }
}
