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
        child: Text(
          'MySwitchView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
