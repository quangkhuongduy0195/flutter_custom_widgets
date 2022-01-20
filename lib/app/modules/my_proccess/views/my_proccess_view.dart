import 'package:custom_widgets/app/widgets/speed_indicator.dart';
import 'package:custom_widgets/app/widgets/speed_indicator_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/my_proccess_controller.dart';

class MyProccessView extends GetView<MyProccessController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyProccessView'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              padding: EdgeInsets.all(10),
              child: SpeedIndicator(
                minSpeed: 0,
                maxSpeed: 500,
                speed: 185,
                animate: true,
                speedWidth: 16,
                inactiveColor: Colors.black12,
                activeColor: Colors.black,
                unitOfMeasurement: 'gallons',
                fractionDigits: 0,
                speedTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 46,
                  fontWeight: FontWeight.w600,
                ),
                unitOfMeasurementTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                ),
                duration: Duration(milliseconds: 200),
              ),
            ),
            Container(
              width: 200,
              height: 200,
              padding: EdgeInsets.all(10),
              child: SpeedIndicatorLine(
                minSpeed: 0,
                maxSpeed: 500,
                speed: 100,
                animate: true,
                speedWidth: 16,
                inactiveColor: Colors.black12,
                activeColor: Colors.black,
                unitOfMeasurement: 'gallons',
                fractionDigits: 0,
                speedTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 46,
                  fontWeight: FontWeight.w600,
                ),
                unitOfMeasurementTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                ),
                duration: Duration(milliseconds: 200),
              ),
            )
          ],
        ),
      ),
    );
  }
}
