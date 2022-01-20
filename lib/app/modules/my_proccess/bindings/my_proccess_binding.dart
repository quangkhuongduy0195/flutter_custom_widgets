import 'package:get/get.dart';

import '../controllers/my_proccess_controller.dart';

class MyProccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyProccessController>(
      () => MyProccessController(),
    );
  }
}
