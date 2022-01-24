import 'package:get/get.dart';

import '../controllers/my_switch_controller.dart';

class MySwitchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MySwitchController>(
      () => MySwitchController(),
    );
  }
}
