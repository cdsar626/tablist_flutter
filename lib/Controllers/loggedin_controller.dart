import 'package:tablist_app/Models/status_item_wl.dart';
import 'package:tablist_app/init.dart';
import 'package:get/get.dart';
import 'package:tablist_app/openai_conf.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

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

  Future<void> newWish(String newWishTitle, String newWishSteps) async {
    List<String> categories = [];
    int? steps = int.tryParse(newWishSteps);
    if (steps == null) {
      print("Error parsing steps");
      return;
    }

    categories = await getCatsFromChatGPT(newWishTitle);
    await UserDataBridge(init.mongoDB).addNewWish(
        newWishTitle,
        init.user.value.username,
        init.user.value.wishes.length,
        steps,
        categories,
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

  Future<void> setCategoriesToOldWishes(username, wishes) async {
    print("Starting add cats to wishes");
    for(int index=0; index < wishes.length; index++) {
      print("Try wish $index");
      if(wishes[index]["categories"] == null) {
        print("loading cats from gpt");
        var categories = await getCatsFromChatGPT(wishes[index]["title"]);
        await UserDataBridge(init.mongoDB).setCategoriesToWish(username, index, categories);
      } else {
        continue;
      }
    }
    await loadWishes();
  }


  Future<List<String>> getCatsFromChatGPT(String wishTitle) async {
    List<String> categories = [];
    final request = ChatCompleteText(messages: [
      Map.of({
        "role": "system",
        "content": "You are a AI that answer with 10 keywords related to a task from a to-do list. I will send you the task title and you will reply only and exclusively with 10 keywords, no more, no less, comma separated. The first keyword is what is about the task, like title of movie or title of anime, sport name, etc. In the next 2-3 keywords categorize what try to achieve the task and include it in the keywords, for example if it is a serie or a videogame or anime, or what kind of other activity it is."
      },
      ),
      Map.of({
        "role": "user",
        "content": "Prompt: $wishTitle",
      },
      ),

    ], maxToken: 300, model: kChatGptTurboModel);

    var body = await openAI.onChatCompletion(request: request);
    var reply = body?.choices.first.message.content;
    categories = reply?.split(",")??[];
    return categories;
  }

}