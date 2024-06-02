import 'package:get/get.dart';

class NavigationController extends GetxController {
  var currentIndex = 0.obs;

  void changeRoute(String route) {
    if (route == "/search") {
      currentIndex.value = 1;
      Get.toNamed(route);
    } else {
      currentIndex.value = 0;
      Get.toNamed(route);
    }
  }
}