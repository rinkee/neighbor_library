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
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      alignment: Alignment(0, 0),
      decoration: BoxDecoration(
        color: Color(0xFFF2F1E9),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image(
            image: AssetImage('assets/icons/${widget.queryDS['name']}.png'),
            width: 50,
          ),
          Text(
            widget.queryDS['count'].toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xff4D4D4D),
            ),
          ),
          Text(
            widget.queryDS['name'].toString().toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4D4D4D),
            ),
          ),
        ],
      ),
    );
    // Positioned(
    //   width: 120,
    //   top: -20,
    //   child: Container(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Image(
    //           image:
    //               AssetImage('assets/icons/${widget.queryDS['name']}.png'),
    //           fit: BoxFit.cover,
    //         ),
    //         Text(widget.queryDS['count'].toString()),
    //         Text(
    //           widget.queryDS['name'].toString(),
    //           style: TextStyle(
    //               fontSize: 16,
    //               fontWeight: FontWeight.bold,
    //               color: Colors.black),
    //         ),
    //       ],
    //     ),
    //   ),
    // )
  }
}
