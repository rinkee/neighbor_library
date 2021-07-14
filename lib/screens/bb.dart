import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:neighbor_library/utilities/constants.dart';

class bb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoScaffold(
        body: Builder(
          builder: (context) => CupertinoPageScaffold(
            backgroundColor: Colors.white,
            navigationBar: CupertinoNavigationBar(
              transitionBetweenRoutes: false,
              middle: Text('Normal Navigation Presentation'),
              trailing: GestureDetector(
                  child: Icon(Icons.arrow_upward),
                  onTap: () => CupertinoScaffold.showCupertinoModalBottomSheet(
                        expand: true,
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => Stack(
                          children: <Widget>[
                            Positioned(
                              height: 40,
                              left: 40,
                              right: 40,
                              bottom: 20,
                              child: MaterialButton(
                                onPressed: () => Navigator.of(context).popUntil(
                                    (route) => route.settings.name == '/'),
                                child: Text('Pop back home'),
                              ),
                            )
                          ],
                        ),
                      )),
            ),
            child: Center(child: Container()),
          ),
        ),
      ),
    );
  }
}
