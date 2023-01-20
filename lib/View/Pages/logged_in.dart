import 'package:tablist_app/Controllers/loggedin_controller.dart';
import 'package:flutter/material.dart';
import 'package:tablist_app/Models/status_item_wl.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:tablist_app/View/Pages/history.dart';
import 'package:dotted_decoration/dotted_decoration.dart';

import 'package:tablist_app/kUI.dart';

class LoggedInPage extends GetView<LoggedInController> {
  const LoggedInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<GlobalKey<ExpansionTileCardState>> cardKeyList = [];
    String newWishInput = '';
    return MaterialApp(
      themeMode: ThemeMode.dark,
      home: Scaffold(
        appBar: AppBar(
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
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: null,
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'happy_msg01'.trParams({
                            'username': controller.init.hiveDB
                                .get('username')
                                .toString()
                          }),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
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
                      double valueOnStart = 0;
                      RxInt progressValue = 0.obs;
                      progressValue.value = controller
                          .init.user.value.wishes[index]['progress']
                          .round();
                      return Container(
                        // margin: const EdgeInsets.symmetric(vertical: 2.5),
                        decoration: DottedDecoration(
                          shape: Shape.line,
                          linePosition: LinePosition.top,
                          dash: const <int>[8, 16],
                        ),
                        key: cardKeyList[index],
                        child: LayoutBuilder(builder: (context, constraints) {
                          return Stack(
                            children: [
                              Obx(() => Positioned.fill(
                                  right: (constraints.maxWidth / 100) *
                                      (100 - progressValue.value.toDouble()),
                                  child: Container(
                                    color: progressColor(status, index),
                                  ),
                                ),
                              ),
                              ExpansionTileCard(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(0.0)),
                                baseColor: tileColor(status, index),
                                expandedColor:
                                    tileColor(status, index),
                                expandedTextColor: const Color(0xFF7A7A7A),
                                title: Text(
                                  controller.init.user.value.wishes[index]
                                      ['title'],
                                  style: const TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(
                                  '${creationDate.year}-${creationDate.month}-${creationDate.day}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black38,
                                  ),
                                ),
                                children: [
                                  Container(
                                    //margin: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0.0),
                                          child: status ==
                                                  StatusItemWL.completed.index
                                              ? null
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        await controller
                                                            .pauseButtonPressed(
                                                                status, index);
                                                        await controller
                                                            .init.user
                                                            .refresh();
                                                        Get.offNamed(
                                                            '/loggedin',
                                                            preventDuplicates:
                                                                false);
                                                      },
                                                      style: null,
                                                      child: Text('paused'.tr),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        await controller
                                                            .abandonedButtonPressed(
                                                                status, index);
                                                        await controller
                                                            .init.user
                                                            .refresh();
                                                        Get.offNamed(
                                                            '/loggedin',
                                                            preventDuplicates:
                                                                false);
                                                      },
                                                      style: null,
                                                      child:
                                                          Text('Abandoned'.tr),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                        Column(
                                          children: [
                                            Center(
                                              child: SizedBox(
                                                height: 100,
                                                width: constraints.maxWidth - 1,
                                                child: Stack(
                                                  children: [

                                                    Obx(() => Positioned(
                                                        top: 0,
                                                        right: (constraints.maxWidth / 100) *
                                                            ((99 - progressValue.value.toDouble()))+1,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              height: 25,
                                                              width: 5,
                                                              color: Colors.black,
                                                              child: GestureDetector(
                                                                dragStartBehavior: DragStartBehavior.down,
                                                                onHorizontalDragUpdate: (details) {
                                                                  valueOnStart = valueOnStart + details.primaryDelta!;
                                                                  print(valueOnStart);
                                                                  progressValue.value = (valueOnStart / constraints.maxWidth * 100).toInt() ;
                                                                },
                                                                onHorizontalDragStart: (details) {
                                                                  valueOnStart = details.localPosition.dx + ((constraints.maxWidth / 100) * progressValue.value);
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Obx(() => Text(progressValue.value
                                                .toString())),
                                            Obx(
                                              () => Slider(
                                                min: 0,
                                                max: 100,
                                                divisions: 100,
                                                value: progressValue.value
                                                    .toDouble(),
                                                onChangeEnd: (endVal) async {
                                                  await controller
                                                      .updateProgress(
                                                          endVal
                                                              .roundToDouble(),
                                                          index);
                                                  await controller.init.user
                                                      .refresh();
                                                  progressValue.value =
                                                      endVal.round();
                                                  if (endVal == 100) {
                                                    Get.offNamed('/loggedin',
                                                        preventDuplicates:
                                                            false);
                                                  }
                                                },
                                                onChanged: (val) {
                                                  progressValue.value =
                                                      val.round();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                              child: const Text('History'),
                                              onPressed: () {
                                                Get.to(() => HistoryPage(
                                                      log: controller
                                                              .init
                                                              .user
                                                              .value
                                                              .wishes[index]
                                                          ['history'],
                                                    ));
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Delete'),
                                              onPressed: () async {
                                                await controller
                                                    .deleteWish(index);
                                                controller.init.user.refresh();
                                              },
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          );
                        }),
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

Color? tileColor(int status, int index) {
  return status == StatusItemWL.paused.index
      ? kColorYellowBase
      : status == StatusItemWL.abandoned.index
          ? kColorRedBase
          : status == StatusItemWL.active.index
              ? kColorGreenBase
              : const Color(0x66C0FFC3);
}

Color? progressColor(int status, int index) {
  return status == StatusItemWL.paused.index
      ? kColorYellowProgressBar
      : status == StatusItemWL.abandoned.index
          ? kColorRedProgressBar
          : kColorGreenProgressBar;
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
