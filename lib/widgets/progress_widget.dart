import 'package:flutter/material.dart';

circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.lightGreenAccent),
    ),
  );
}

linearProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.lightGreenAccent),
    ),
  );
}

boxProgress() {
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: 3,
    itemBuilder: (context, index) => Padding(
      padding: const EdgeInsets.only(right: 7, left: 7),
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
    ),
  );
}
