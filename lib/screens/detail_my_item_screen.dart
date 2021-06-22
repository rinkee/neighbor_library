import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailMyItemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Get.arguments['postTitle']),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Image.network(
                  Get.arguments['postImageURL'],
                  width: Get.width,
                  fit: BoxFit.fitHeight,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Get.arguments['postTitle'],
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 13),
                    Text(
                      '여자친구랑 여행을 가기 위해 신경을 썻다여자친구랑 여행을 가기 위해 신경을 썻다여자친구랑 여행을 가기 위해 신경을 썻다',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 30),
                    Text(
                      '기분?',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
