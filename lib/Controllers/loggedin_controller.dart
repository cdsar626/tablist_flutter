import 'package:tablist_app/Models/status_item_wl.dart';
import 'package:tablist_app/init.dart';
import 'package:get/get.dart';

import '../Models/User.dart';
import '../Data/user_data_bridge.dart';

class LoggedInController extends GetxController {
  final Init init;

  LoggedInController(this.init);

  void clearUser() {
    init.user.value = User(
      '',
      '',
      DateTime.now(),
      DateTime.now(),
      [],
    );
  }

  Future<void> newWish(String newWishTitle) async {
    await UserDataBridge(init.mongoDB).addNewWish(
        newWishTitle, init.user.value.username, init.user.value.wishes.length);
  }

  Future<void> deleteWish(int index) async {
    await UserDataBridge(init.mongoDB).deleteWish(
        init.user.value.username, index, init.user.value.wishes.length
    );
    await loadWishes();
  }

  Future<void> loadWishes() async {
    var wishes = await UserDataBridge(init.mongoDB).getWishes(
        init.user.value.username);
    init.user.value.wishes = wishes;
  }

  Future<void> logOut() async {
    await init.hiveDB.put('isLoggedIn', false);
    await init.hiveDB.put('username', '');
    clearUser();
  }

  Future<void> updateWishesSort(String username, int oldIndex,
      int newIndex) async {
    await UserDataBridge(init.mongoDB).updateWishesSortDB(
        username, oldIndex, newIndex);
  }

  Future<void> setWishStatus(username, int index, StatusItemWL status) async {
    await UserDataBridge(init.mongoDB).setWishStatus(username, index, status);
    await loadWishes();
  }

  Future<void> pauseButtonPressed(status, index) async {
    if (status == StatusItemWL.paused.index) {
      await setWishStatus(
          init.user.value.username,
          index,
          StatusItemWL.active);
    } else {
      await setWishStatus(
          init.user.value.username,
          index,
          StatusItemWL.paused);
    }
  }

  Future<void> abandonedButtonPressed(status, index) async {
    if (status == StatusItemWL.abandoned.index) {
      await setWishStatus(
          init.user.value.username,
          index,
          StatusItemWL.active);
    } else {
      await setWishStatus(
          init.user.value.username,
          index,
          StatusItemWL.abandoned);
    }
  }

 Future<void> updateProgress(double endVal, int index) async {
     await UserDataBridge(init.mongoDB).updateProgress(endVal, index, init.user.value.username);
     await loadWishes();
  }





}