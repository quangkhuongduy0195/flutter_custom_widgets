import 'package:custom_widgets/app/widgets/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/my_switch_controller.dart';

class MySwitchView extends GetView<MySwitchController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MySwitchView'),
        centerTitle: true,
      ),
      body: Center(
        child: Obx(
          () => CustomSwitch(
            value: controller.valueSwitch.value,
            onChanged: (bool value) {
              controller.valueSwitch.value = value;
            },
          ),
        ),
      ),
    );
  }
}
