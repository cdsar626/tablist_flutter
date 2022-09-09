import 'package:tablist_app/Controllers/loggedin_controller.dart';
import 'package:tablist_app/Models/status_item_wl.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

class LoggedInPage extends GetView<LoggedInController> {
  const LoggedInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<GlobalKey<ExpansionTileCardState>> cardKeyList = [];
    String newWishInput = '';
    return NeumorphicApp(
      themeMode: ThemeMode.dark,
      home: Scaffold(
        appBar: NeumorphicAppBar(
          padding: 0,
          title: const Text('TABList'),
          titleSpacing: 0,
          leading: TextButton(
              onPressed: () async {
                await controller.logOut();
                Get.offAllNamed('/home');
              },
              child: const Icon(
                Icons.logout_rounded,
                size: 40,
              )),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: NeumorphicButton(
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'happy_msg01'.trParams({'username': controller.init.hiveDB.get('username').toString()}),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  onPressed: null,
                ),
              ),
              Expanded(
                child: Obx(
                  () => ReorderableListView.builder(
                    dragStartBehavior: DragStartBehavior.down,
                    onReorder: (oldIndex, newIndex) async {
                      // these 'if' are for fix the bugs of the onReorder method
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      if (oldIndex == newIndex) {
                        return;
                      }

                      reorderLocalWishesList(oldIndex, newIndex, controller);
                      // To keep current state of expanded/collapsed when reordering
                      cardKeyList.insert(
                          newIndex, cardKeyList.removeAt(oldIndex));

                      // We call updateWishesSort to update the database with the
                      // new values of the user index
                      await controller.updateWishesSort(
                          controller.init.user.value.username,
                          oldIndex,
                          newIndex);
                    },
                    itemCount: controller.init.user.value.wishes.length,
                    itemBuilder: (context, index) {
                      DateTime creationDate =
                          controller.init.user.value.wishes[index]['creation'];
                      int status =
                          controller.init.user.value.wishes[index]['status'];
                      //var currentItem = controller.init.user.value.wishes[index];
                      cardKeyList.add(GlobalKey());
                      RxInt progressValue = 0.obs;
                      progressValue.value = controller
                          .init.user.value.wishes[index]['progress'].round();
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 2.5),
                        key: cardKeyList[index],
                        child: ExpansionTileCard(
                          baseColor: tileColor(status, index, controller),
                          expandedColor: tileColor(status, index, controller),
                          expandedTextColor: const Color(0xFF7A7A7A),
                          title: Text(
                              controller.init.user.value.wishes[index]['title'],
                          style: const TextStyle(
                            color: Colors.black
                          ),),
                          subtitle: Text(
                            '${creationDate.year}-${creationDate.month}-${creationDate.day}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black38,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20.0),
                              child: status == StatusItemWL.completed.index? null : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  NeumorphicButton(
                                    child: Text('paused'.tr),
                                    onPressed: () async {
                                      await controller.pauseButtonPressed(status, index);
                                      await controller.init.user.refresh();
                                      Get.offNamed('/loggedin', preventDuplicates: false);
                                    },
                                    style: NeumorphicStyle(
                                      depth: status == StatusItemWL.paused.index
                                          ? -10
                                          : 10,
                                      boxShape: const NeumorphicBoxShape.stadium(),
                                    ),
                                  ),
                                  NeumorphicButton(
                                    child: Text('Abandoned'.tr),
                                    onPressed: () async {
                                      await controller.abandonedButtonPressed(status, index);
                                      await controller.init.user.refresh();
                                      Get.offNamed('/loggedin', preventDuplicates: false);
                                    },
                                    style: NeumorphicStyle(
                                        depth:
                                            status == StatusItemWL.abandoned.index
                                                ? -4
                                                : 4,
                                        boxShape:
                                            const NeumorphicBoxShape.stadium()),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Obx(
                                () => NeumorphicSlider(
                                  min: 0,
                                  max: 100,
                                  value: progressValue.value.toDouble(),
                                  onChangeEnd: (endVal) async {
                                    await controller.updateProgress(endVal, index);
                                    await controller.init.user.refresh();
                                    progressValue.value = endVal.round();
                                    if (endVal == 100) {
                                      Get.offNamed('/loggedin', preventDuplicates: false);
                                    }
                                  },
                                  onChanged: (val) {
                                    progressValue.value = val.round();
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const TextButton(
                                    child: Text('History'),
                                    onPressed: null,
                                  ),
                                  TextButton(
                                    child: const Text('Delete'),
                                    onPressed: () async {
                                      await controller.deleteWish(index);
                                      controller.init.user.refresh();
                                    },
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Get.defaultDialog(
                title: 'Add new wish',
                content: TextField(
                  onChanged: (value) => newWishInput = value,
                ),
                confirm: TextButton(
                    onPressed: () async {
                      Get.back();
                      await controller.newWish(newWishInput);
                      await controller.loadWishes();
                      controller.init.user.refresh();
                    },
                    child: const Text('Send')));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

}

Color? tileColor(int status, int index, controller) {
  return status == StatusItemWL.paused.index
      ? const Color(0xFFFFF9C4)
      : status == StatusItemWL.abandoned.index
      ? const Color(0xB7FF7A7A)
      : status == StatusItemWL.active.index
      ? const Color(0xFFD7D7D7)
      : Colors.greenAccent;
}


void reorderLocalWishesList(oldIndex, newIndex, controller) {
  // Initialization for reusing code
  int auxold = oldIndex;
  int auxnew = newIndex;
  int operationValue = -1;

  // We can invert the limits (new and old indexes) to use the same for loop
  if (newIndex < oldIndex) {
    operationValue = 1; // for sum (or subtract) the index indicator of DB
    auxold = newIndex;
    auxnew = oldIndex;
  }

  // We remove the initial item from list, then we set the new
  // index (the one used to track the custom user index on bd)
  // to the items affected
  var item = controller.init.user.value.wishes.removeAt(oldIndex);
  for (int i = auxold; i < auxnew; i++) {
    controller.init.user.value.wishes[i]['indexAtUserList'] =
        controller.init.user.value.wishes[i]['indexAtUserList'] +
            operationValue;
  }
  // We set the new index to the item we removed from the list
  // and insert it again in the list at the new index
  item['indexAtUserList'] = newIndex;
  controller.init.user.value.wishes.insert(newIndex, item);
}
