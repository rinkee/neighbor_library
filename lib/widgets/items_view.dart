import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ItemsView extends StatefulWidget {
  QueryDocumentSnapshot queryDS;
  ItemsView({@required this.queryDS});
  @override
  _ItemsViewState createState() => _ItemsViewState();
}

class _ItemsViewState extends State<ItemsView> {
  String iconURL;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getIconURL().then((value) => print(iconURL));
  }

  Future<void> _getIconURL() async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('icons/${widget.queryDS['name']}.png')
        .getDownloadURL();
    setState(() {
      iconURL = downloadURL;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // Image.network(
          //   _getImage().toString(),
          //   height: 100,
          //   fit: BoxFit.cover,
          // ),
          Image.network(iconURL),
          Text(
            widget.queryDS['name'].toString(),
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
