import 'package:get/get.dart';

import 'package:tablist_app/Models/user.dart';
import 'package:tablist_app/Data/user_data_bridge.dart';

import '../init.dart';

class HomeController extends GetxController {
  final Init init;

  HomeController(this.init);

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

  Future<bool> userExists(String username) async{
    return await UserDataBridge(init.mongoDB).userExists(username);
  }

  Future<void> createUser(String username) async {
    await UserDataBridge(init.mongoDB).createUser(username);
  }

  Future<void> loadUser(String username) async {
    init.user.value = await UserDataBridge(init.mongoDB).loadUser(username);
  }

}