import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                '이웃집 도서관',
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              bottom: TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                    text: '책 빌리기',
                  ),
                  Tab(
                    text: '책 등록하기',
                  ),
                ],
              ),
              elevation: 0,
            ),
            body: TabBarView(
              children: [
                Container(
                    child: Column(
                  children: [
                    Text('aa'),
                    Text('aa'),
                    Text('aa'),
                  ],
                )),
                Text('bb'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
