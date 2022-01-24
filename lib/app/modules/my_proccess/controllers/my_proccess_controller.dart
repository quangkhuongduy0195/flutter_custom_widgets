import 'dart:async';

import 'package:get/get.dart';

class MyProccessController extends GetxController {
  //TODO: Implement MyProccessController

  RxDouble count = RxDouble(0);
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  bool isUserTouch = false;

  void onValueToServer() {
    Future.delayed(Duration(milliseconds: 1000), () {
      if (!isUserTouch) {
        print('onValueToServer');
      }
    });
  }

  Timer? timer;
  double minValue = 0;
  double maxValue = 140;
  cancelTimer() {
    timer?.cancel();
  }

  void onUp({bool isEnd = false}) {
    if (!isEnd) {
      timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (count.value < maxValue) {
          count.value = count.value + 1;
        } else {
          cancelTimer();
        }
      });
    } else {
      cancelTimer();
    }
  }

  void onDown({bool isEnd = false}) {
    if (!isEnd) {
      timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (count.value > minValue) {
          count.value = count.value - 1;
        } else {
          cancelTimer();
        }
      });
    } else {
      cancelTimer();
    }
  }
}
