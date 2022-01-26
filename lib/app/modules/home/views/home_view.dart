import 'package:custom_widgets/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text('Slider'),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () {
                    Get.toNamed(Routes.MY_SLIDER);
                  },
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  title: Text('Proccess'),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () {
                    Get.toNamed(Routes.MY_PROCCESS);
                  },
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  title: Text('Swtich'),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () {
                    Get.toNamed(Routes.MY_SWITCH);
                  },
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  title: Text('Color'),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () {
                    Get.toNamed(Routes.MY_CIRCLE_COLOR);
                  },
                ),
                Divider(
                  thickness: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
