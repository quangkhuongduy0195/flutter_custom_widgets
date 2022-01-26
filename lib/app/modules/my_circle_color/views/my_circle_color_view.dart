import 'package:custom_widgets/app/widgets/circle_color.dart';
import 'package:custom_widgets/app/widgets/thumb_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/my_circle_color_controller.dart';

class MyCircleColorView extends GetView<MyCircleColorController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyCircleColorView'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 18,
              ),
              Obx(
                () => Container(
                  width: 100,
                  height: 100,
                  color: controller.colorSelected.value,
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Obx(
                () => CircleColor(
                  controller: controller.colorController.value,
                  onChanged: (color) {
                    controller.colorController.value =
                        CircleColorController(initialColor: color);
                    controller.colorCircle.value = color;
                    controller.onColorSelected();
                  },
                  onEnded: (color) {},
                  size: const Size(300, 300),
                  strokeWidth: 20,
                  thumbSize: 48,
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Obx(
                () => SliderColor(
                  colorEnd: controller.colorCircle.value,
                  onChanged: (double value) {
                    controller.valueSaturation.value = value;
                    controller.onColorSelected();
                  },
                  width: 300,
                  sizeThumb: 30,
                  value: controller.valueSaturation.value,
                  colorStart: Color(0xffffffff),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Obx(
                () => SliderColor(
                  onChanged: (double value) {
                    controller.valueLightness.value = value;
                    controller.onColorSelected();
                  },
                  width: 300,
                  sizeThumb: 30,
                  value: controller.valueLightness.value,
                  colorStart: Color(0xff000000),
                  colorEnd: Color(0xffffffff),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SliderColor extends StatelessWidget {
  const SliderColor({
    Key? key,
    required this.colorEnd,
    required this.onChanged,
    required this.width,
    required this.value,
    this.sizeThumb = 20,
    required this.colorStart,
  }) : super(key: key);

  final Color colorEnd;
  final Color colorStart;

  final ValueChanged<double> onChanged;

  final double width;

  final double value;

  final double sizeThumb;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: _onDown,
      onPanCancel: _onCancel,
      onHorizontalDragStart: _onStart,
      onHorizontalDragUpdate: _onUpdate,
      onHorizontalDragEnd: _onEnd,
      onVerticalDragStart: _onStart,
      onVerticalDragUpdate: _onUpdate,
      onVerticalDragEnd: _onEnd,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: sizeThumb,
            width: width,
          ),
          Container(
            height: sizeThumb * 0.5,
            width: width,
            margin: EdgeInsets.symmetric(horizontal: width * 0.04),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[
                  colorStart,
                  colorEnd,
                ],
              ),
            ),
          ),
          Positioned(
            left: value * (width - sizeThumb / 3),
            child: ThumbCustom(
              size: sizeThumb,
              color: Colors.white,
              borderWidth: 1,
              borderColor: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _onDown(DragDownDetails details) {
    update(details.localPosition.dx);
  }

  void _onStart(DragStartDetails details) {
    update(details.localPosition.dx);
  }

  void _onUpdate(DragUpdateDetails details) {
    update(details.localPosition.dx);
  }

  void update(double localPosition) {
    var val = localPosition / width;
    if (val < 0) {
      val = 0;
    }
    if (val > 1) {
      val = 1.0;
    }
    onChanged(val);
  }

  void _onEnd(DragEndDetails details) {
    // _scaleController.forward();
    // widget.onEnded();
  }

  void _onCancel() {}
}
