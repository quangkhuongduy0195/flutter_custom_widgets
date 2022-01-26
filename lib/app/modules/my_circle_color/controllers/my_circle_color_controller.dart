import 'package:custom_widgets/app/widgets/circle_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyCircleColorController extends GetxController
    with GetTickerProviderStateMixin {
  //TODO: Implement MyCircleColorController
  Rx<CircleColorController> colorController = new Rx<CircleColorController>(
    new CircleColorController(
      initialColor: Colors.red,
    ),
  );

  Rx<Color> colorCircle = Rx<Color>(Colors.red);
  Rx<Color> colorSelected = Rx<Color>(Colors.red);

  late Rx<AnimationController> lightnessController;
  RxDouble valueSaturation = RxDouble(1);
  RxDouble valueLightness = RxDouble(0.6);
  final count = 0.obs;
  @override
  void onInit() {
    lightnessController =
        Rx<AnimationController>(AnimationController(vsync: this));
    colorSelected.value = _color;
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    colorController.close();
  }

  void increment() => count.value++;

  void onColorSelected() {
    colorSelected.value = _color;
  }

  Color get _color {
    final hslColor = HSLColor.fromColor(colorCircle.value);
    return HSLColor.fromAHSL(
      1,
      hslColor.hue,
      valueSaturation.value,
      valueLightness.value < 0 ? 0 : valueLightness.value,
    ).toColor();
  }
}
