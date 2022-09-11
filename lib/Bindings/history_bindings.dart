import 'package:tablist_app/init.dart';
import 'package:get/get.dart';

import '../Controllers/history_controller.dart';

class HistoryBinding implements Bindings {
  final Init init;
  HistoryBinding(this.init);
  @override
  void dependencies() {
    Get.lazyPut(() => HistoryController(init));
  }
}