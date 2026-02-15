import 'package:tablist_app/init.dart';
import 'package:get/get.dart';

import '../Controllers/loggedin_controller.dart';

class LoggedInBinding implements Bindings {
  final Init init;
  LoggedInBinding(this.init);
  @override
  void dependencies() {
    Get.lazyPut(() => LoggedInController(init));
  }
}