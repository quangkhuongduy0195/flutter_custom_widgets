import 'package:get/get.dart';

import '../controllers/my_slider_controller.dart';

class MySliderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MySliderController>(
      () => MySliderController(),
    );
  }
}
