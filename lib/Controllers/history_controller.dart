import 'package:get/get.dart';

import 'package:tablist_app/Models/User.dart';
import 'package:tablist_app/Data/user_data_bridge.dart';

import '../init.dart';

class HistoryController extends GetxController {
  final Init init;

  HistoryController(this.init);

  Rx<User>? getUser() {
    return init.user;
  }

  void setUsername(String username) {
    init.user.value = User(
      username,
      username+'@gmail.com',
      DateTime.now(),
      DateTime.now(),
      [],
    );
  }

}