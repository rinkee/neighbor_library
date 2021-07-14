import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:neighbor_library/utilities/constants.dart';
import 'package:neighbor_library/widgets/progress_widget.dart';

class MyLookScreen extends StatefulWidget {
  @override
  _MyLookScreenState createState() => _MyLookScreenState();
}

class _MyLookScreenState extends State<MyLookScreen> {
  int changeGrid = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Look',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(changeGrid == 1 ? Feather.grid : Feather.square),
              onPressed: () {
                // Get.to(CropPage());
                setState(() {
                  if (changeGrid == 1) {
                    changeGrid = 2;
                    // changeGrid = false;
                  } else {
                    changeGrid = 1;
                    // changeGrid = true;
                  }
                });
              },
              color: Colors.black54,
            ),
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<QuerySnapshot>(
          future: usersRef
              .doc(authController.firebaseUser.uid)
              .collection('dailyLooks')
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return circularProgress();
            }
            if (!snapshot.hasData) {
              return Text('no data');
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: new GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: changeGrid,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) => Container(
                  // margin: index % 2 == 0
                  //     ? EdgeInsets.only(bottom: 20)
                  //     : EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            snapshot.data.docs[index]['postImageURL'])),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image.network(
                      //   snapshot.data.docs[index]['postImageURL'],
                      //   width: Get.width,
                      //   fit: BoxFit.cover,
                      //
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 80),
                      //   child: Text(
                      //     snapshot.data.docs[index]['postTitle'].toString(),
                      //     style: TextStyle(
                      //         fontSize: 18,
                      //         fontWeight: FontWeight.bold,
                      //         color: Colors.black),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 0),
                      //   child: Text(
                      //     snapshot.data.docs[index]['postTitle'].toString(),
                      //     style:
                      //         TextStyle(fontSize: 14, color: Color(0xFF222222)),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
