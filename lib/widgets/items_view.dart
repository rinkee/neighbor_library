import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:get/get.dart';

class ItemsView extends StatefulWidget {
  QueryDocumentSnapshot queryDS;
  ItemsView({@required this.queryDS});
  @override
  _ItemsViewState createState() => _ItemsViewState();
}

class _ItemsViewState extends State<ItemsView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment(0, 0),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(15))),
        ),
        Positioned(
          width: 120,
          top: -20,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image:
                      AssetImage('assets/icons/${widget.queryDS['name']}.png'),
                  fit: BoxFit.cover,
                ),
                Text(widget.queryDS['count'].toString()),
                Text(
                  widget.queryDS['name'].toString(),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
