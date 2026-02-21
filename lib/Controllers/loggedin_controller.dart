import 'package:tablist_app/Models/status_item_wl.dart';
import 'package:tablist_app/init.dart';
import 'package:get/get.dart';

import '../Models/user.dart';
import '../Data/user_data_bridge.dart';

class LoggedInController extends GetxController {
  final Init init;

  late RxBool showActive;
  late RxBool showPaused;
  late RxBool showAbandoned;
  late RxBool showCompleted;

  LoggedInController(this.init) {
    bool activeVal = init.hiveDB?.get('showActive', defaultValue: true) as bool? ?? true;
    showActive = activeVal.obs;

    bool pausedVal = init.hiveDB?.get('showPaused', defaultValue: true) as bool? ?? true;
    showPaused = pausedVal.obs;

    bool abandonedVal = init.hiveDB?.get('showAbandoned', defaultValue: true) as bool? ?? true;
    showAbandoned = abandonedVal.obs;

    bool completedVal = init.hiveDB?.get('showCompleted', defaultValue: true) as bool? ?? true;
    showCompleted = completedVal.obs;
  }

  void toggleFilter(String filter) {
    if (filter == 'active') {
      showActive.toggle();
      init.hiveDB?.put('showActive', showActive.value);
    } else if (filter == 'paused') {
      showPaused.toggle();
      init.hiveDB?.put('showPaused', showPaused.value);
    } else if (filter == 'abandoned') {
      showAbandoned.toggle();
      init.hiveDB?.put('showAbandoned', showAbandoned.value);
    } else if (filter == 'completed') {
      showCompleted.toggle();
      init.hiveDB?.put('showCompleted', showCompleted.value);
    }
  }

  List<int> get filteredIndices {
    List<int> indices = [];
    for (int i = 0; i < init.user.value.wishes.length; i++) {
      int status = init.user.value.wishes[i]['status'];
      if (status == StatusItemWL.active.index && showActive.value) {
        indices.add(i);
      } else if (status == StatusItemWL.paused.index && showPaused.value) {
        indices.add(i);
      } else if (status == StatusItemWL.abandoned.index && showAbandoned.value) {
        indices.add(i);
      } else if (status == StatusItemWL.completed.index && showCompleted.value) {
        indices.add(i);
      }
    }
    return indices;
  }


  void clearUser() {
    init.user.value = User(
      '',
      '',
      DateTime.now(),
      DateTime.now(),
      [],
    );
  }

  Future<void> newWish(String newWishTitle, String newWishSteps) async {
    int? steps = int.tryParse(newWishSteps);
    if (steps == null) {
      return;
    }
    await UserDataBridge(init.mongoDB).addNewWish(
        newWishTitle,
        init.user.value.username,
        init.user.value.wishes.length,
        steps,
    );
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

 Future<void> updateProgress(double endVal, int index, int maxSteps) async {
     await UserDataBridge(init.mongoDB).updateProgress(endVal, index, init.user.value.username, maxSteps);
     await loadWishes();
  }
}