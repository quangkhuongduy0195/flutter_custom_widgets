import 'package:custom_widgets/app/widgets/slider_custom.dart';
import 'package:custom_widgets/app/widgets/slider_custom2.dart' as s;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/my_slider_controller.dart';

class MySliderView extends GetView<MySliderController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MySliderView'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => SliderCustom(
              thumbSize: 16,
              trackHeight: 12,
              value: controller.valueSlider.value,
              min: 0,
              max: 100,
              onChanged: (double value) {
                controller.valueSlider.value = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: s.SliderCustom(),
          ),
        ],
      ),
    );
  }
}
