import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:neighbor_library/screens/active_screen.dart';
import 'package:neighbor_library/screens/bb.dart';
import 'package:neighbor_library/screens/upload_community_post_screen.dart';
import 'package:neighbor_library/services/controller/noti_contriller.dart';
import 'package:neighbor_library/utilities/constants.dart';
import 'package:neighbor_library/widgets/custom_appbar.dart';
import 'package:neighbor_library/widgets/progress_widget.dart';

class aa extends StatelessWidget {
  final notiController = Get.put(NotiController());
  var changeColor;
  var String = 'add'.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(onTap: () {
          String.value = '이메일';
          print(String.value);
        }, child: Obx(() {
          return TextField(
            onTap: () {},
            decoration:
                InputDecoration(hintText: '번호를입력해주세요', labelText: String.value),
          );
        })),
      ),
    );
  }
}
