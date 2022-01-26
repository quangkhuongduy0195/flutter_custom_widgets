import 'package:get/get.dart';

import '../controllers/my_circle_color_controller.dart';

class MyCircleColorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyCircleColorController>(
      () => MyCircleColorController(),
    );
  }
}
