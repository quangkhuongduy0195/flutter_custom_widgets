import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/my_proccess/bindings/my_proccess_binding.dart';
import '../modules/my_proccess/views/my_proccess_view.dart';
import '../modules/my_slider/bindings/my_slider_binding.dart';
import '../modules/my_slider/views/my_slider_view.dart';
import '../modules/my_switch/bindings/my_switch_binding.dart';
import '../modules/my_switch/views/my_switch_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.MY_SLIDER,
      page: () => MySliderView(),
      binding: MySliderBinding(),
    ),
    GetPage(
      name: _Paths.MY_PROCCESS,
      page: () => MyProccessView(),
      binding: MyProccessBinding(),
    ),
    GetPage(
      name: _Paths.MY_SWITCH,
      page: () => MySwitchView(),
      binding: MySwitchBinding(),
    ),
  ];
}
