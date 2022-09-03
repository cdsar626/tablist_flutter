import 'package:clean_bucket_list/init.dart';
import 'package:get/get.dart';

import '../Controllers/home_controller.dart';

class HomeBinding implements Bindings {
  final Init init;
  HomeBinding(this.init);
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(init));
  }
}