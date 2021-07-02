import 'package:flutter/material.dart';

class ProgressExample extends StatefulWidget {
  ProgressExample({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProgressExampleState createState() => _ProgressExampleState();
}

class _ProgressExampleState extends State<ProgressExample> {
  bool _isDialogVisible = false;

  void _showDialog() {
    setState(() {
      _isDialogVisible = true;
    });
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isDialogVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Content',
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showDialog,
            tooltip: 'Send',
            child: Icon(Icons.send),
          ),
        ),
        Visibility(
            visible: false,
            child: Container(
              color: Colors.black26,
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                  backgroundColor: Colors.white,
                ),
              ),
            ))
      ],
    );
  }
}
