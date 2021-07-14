import 'package:get/get.dart';
import 'package:neighbor_library/services/controller/post_controller.dart';
// controller
import 'package:neighbor_library/services/controller/screen_controller.dart';
import 'package:neighbor_library/services/controller/auth_controller.dart';

class InstanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.put(ScreenController());
    Get.put(PostController());
  }
}
