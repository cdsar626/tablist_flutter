<<<<<<< HEAD
import 'package:get/get.dart';

import 'package:tablist_app/Models/user.dart';

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
      '$username@gmail.com',
      DateTime.now(),
      DateTime.now(),
      [],
    );
  }

=======
import 'package:get/get.dart';

import 'package:tablist_app/Models/user.dart';

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
      '$username@gmail.com',
      DateTime.now(),
      DateTime.now(),
      [],
    );
  }

>>>>>>> 31280dec0883ba271a2c8b5fbde3c9ca558be329
}