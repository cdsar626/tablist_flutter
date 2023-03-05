import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:tablist_app/Controllers/loggedin_controller.dart';
import 'package:flutter/material.dart';
import 'package:tablist_app/Models/status_item_wl.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:tablist_app/View/Pages/history.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:material_dialogs/material_dialogs.dart';

import 'package:tablist_app/kUI.dart';

class LoggedInPage extends GetView<LoggedInController> {
  const LoggedInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<GlobalKey<ExpansionTileCardState>> cardContainerKeyList = [];
    final List<GlobalKey<ExpansionTileCardState>> cardExpansionKeyList = [];
    String newWishInput = '';
    TextEditingController newWishInputController = TextEditingController();
    String newWishSteps = '';
    TextEditingController newWishStepsController = TextEditingController();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TABList'),
          //titleSpacing: 0,
          leading: TextButton(
              onPressed: () async {
                await controller.logOut();
                Get.offAllNamed('/home');
              },
              child: const Icon(
                EvaIcons.logOut,
                size: 40,
              )),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 24.0),
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
                      dragStartBehavior: DragStartBehavior.start,
                      onReorder: (oldIndex, newIndex) async {
                          // these 'if' are for fix the bugs of the onReorder method
                        if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          if (oldIndex == newIndex) {
                            return;
                          } else {

                          }

                          reorderLocalWishesList(oldIndex, newIndex, controller);
                          // To keep current state of expanded/collapsed when reordering
                          cardContainerKeyList.insert(
                              newIndex, cardContainerKeyList.removeAt(oldIndex));

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
                        List historyOfiWish = controller.init.user.value.wishes[index]["history"];
                        DateTime updateDate = historyOfiWish[historyOfiWish.length - 1]["when"];
                        int status =
                            controller.init.user.value.wishes[index]['status'];
                        //var currentItem = controller.init.user.value.wishes[index];
                        cardContainerKeyList.add(GlobalKey());
                        cardExpansionKeyList.add(GlobalKey());
                        double valueOnStartDragProgress = 0;
                        RxBool showSubtitle = true.obs;
                        RxInt progressValue = 0.obs;
                        progressValue.value = controller
                            .init.user.value.wishes[index]['progress']
                            .round();
                        Color sliderColor = kColorSliderBase;
                        //if wish have no steps defaults to 100
                        int maxSteps = controller.init.user.value.wishes[index]['steps']??100;
                        return Container(
                          // margin: const EdgeInsets.symmetric(vertical: 2.5),
                          decoration: DottedDecoration(
                            shape: Shape.line,
                            linePosition: LinePosition.top,
                            dash: const <int>[16, 32],
                          ),
                          key: cardContainerKeyList[index],
                          child: LayoutBuilder(builder: (context, constraints) {
                            return Stack(
                              children: [
                                // Add a new background color filled until percent completed
                                Obx(() => Positioned.fill(
                                    right: (constraints.maxWidth / maxSteps) *
                                        (maxSteps - progressValue.value.toDouble()),
                                    child: Container(
                                      color: progressColor(status, index),
                                    ),
                                  ),
                                ),
                                Obx( () {
                                  return ExpansionTileCard(
                                    key: cardExpansionKeyList[index],
                                    onExpansionChanged: (isExpanded) {
                                      showSubtitle.value = !isExpanded;
                                    },
                                    //finalPadding: EdgeInsets.zero,
                                    duration: const Duration(milliseconds: 150),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(0.0)),
                                    baseColor: tileColor(status, index),
                                    shadowColor: Colors.transparent,
                                    expandedColor:
                                    tileColor(status, index),
                                    //expandedTextColor: const Color(0xFF7A7A7A),
                                    title: Text(
                                      controller.init.user.value.wishes[index]
                                      ['title'],
                                      style: kTextStyleTaskTitle,
                                    ),
                                    subtitle: AnimatedOpacity(
                                      opacity: showSubtitle.value == true? 1.0 : 0.0,
                                      duration: const Duration(milliseconds: 100),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            'U:${updateDate.year}-${updateDate
                                                .month}-${updateDate.day}',
                                            style: kTextStyleTaskSubtitle,
                                          ),
                                          Text(
                                            'C:${creationDate.year}-${creationDate
                                                .month}-${creationDate.day}',
                                            style: kTextStyleTaskSubtitle,
                                          )
                                        ],
                                      ),
                                    ),
                                    children: [
                                      Column(
                                        children: [
                                          // Buttons
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(0,0,0,16.0),
                                            child: status ==
                                                StatusItemWL.completed.index
                                                ? null
                                                : Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceAround,
                                              children: [
                                                OutlinedButton(
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
                                                  child: status == StatusItemWL.paused.index? Text('continue'.tr) : Text('pause'.tr),
                                                ),
                                                OutlinedButton(
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
                                                  child: status == StatusItemWL.abandoned.index? Text('continue'.tr) : Text('abandon'.tr),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Slider and percentage
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: 48,
                                                width: constraints.maxWidth - 1,
                                                child: Stack(
                                                  children: [
                                                    Obx(() =>
                                                    // Custom slider positioned respect percentage completed
                                                        Positioned(
                                                          top: 0,
                                                          right: sliderHPosAndConstraints(constraints, progressValue, maxSteps),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                color: sliderColor),
                                                                height: 32,
                                                                width: 8,
                                                                child: GestureDetector(
                                                                  dragStartBehavior: DragStartBehavior
                                                                      .down,
                                                                  onTap: () {
                                                                    //showSubtitle.value = cardKeyList[index].currentState?.mounted as bool;
                                                                  },
                                                                  onHorizontalDragUpdate: (details) {
                                                                    // We read the progressValue settled when dragging started and use it to update
                                                                    // with current delta from last tick
                                                                    valueOnStartDragProgress = valueOnStartDragProgress + details.primaryDelta!;
                                                                    // We verify constrains
                                                                    double finalValue = valueOnStartDragProgress;
                                                                    if (valueOnStartDragProgress < 0) {
                                                                      finalValue = 0;
                                                                    }
                                                                    if (valueOnStartDragProgress > constraints.maxWidth) {
                                                                      finalValue = constraints.maxWidth;
                                                                    }
                                                                    progressValue.value = (finalValue / constraints.maxWidth * maxSteps).toInt();
                                                                  },
                                                                  onHorizontalDragStart: (
                                                                      details) {
                                                                    sliderColor = kColorSliderDragged;
                                                                    valueOnStartDragProgress =
                                                                        details
                                                                            .localPosition
                                                                            .dx +
                                                                            ((constraints
                                                                                .maxWidth /
                                                                                maxSteps) *
                                                                                progressValue
                                                                                    .value);
                                                                  },
                                                                  onHorizontalDragEnd: (details) async {
                                                                    sliderColor = kColorSliderBase;
                                                                    var endVal = progressValue.value;
                                                                    await controller
                                                                        .updateProgress(
                                                                        endVal
                                                                            .roundToDouble(),
                                                                        index, maxSteps);
                                                                    await controller.init.user
                                                                        .refresh();
                                                                    progressValue.value =
                                                                        endVal.round();
                                                                    if (endVal == maxSteps) {
                                                                      Get.offNamed(
                                                                          '/loggedin',
                                                                          preventDuplicates:
                                                                          false);
                                                                    }
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
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  status != StatusItemWL.completed.index && progressValue > 0? OutlinedButton(
                                                    onPressed: () async {
                                                      await controller
                                                          .updateProgress(
                                                          progressValue.value - 1
                                                              .roundToDouble(),
                                                          index, maxSteps);
                                                      await controller.init.user
                                                          .refresh();
                                                    },
                                                    child: const Text("-"),
                                                  ): const SizedBox(),
                                                  const SizedBox(width: 10,),
                                                  Obx(() =>
                                                      Text("${progressValue.value}/$maxSteps")),
                                                  const SizedBox(width: 10,),
                                                  progressValue < maxSteps? OutlinedButton(
                                                    onPressed: () async {
                                                      await controller
                                                          .updateProgress(
                                                          progressValue.value + 1
                                                              .roundToDouble(),
                                                          index, maxSteps);
                                                      await controller.init.user
                                                          .refresh();
                                                    },
                                                    child: const Text("+"),
                                                  ):const SizedBox(),
                                                ],
                                              ),
                                              const SizedBox(height: 4,),
                                              /*Obx(
                                                    () =>
                                                    Slider(
                                                      min: 0,
                                                      max: 100,
                                                      divisions: 100,
                                                      value: progressValue.value
                                                          .toDouble(),
                                                      onChangeEnd: (
                                                          endVal) async {
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
                                                          Get.offNamed(
                                                              '/loggedin',
                                                              preventDuplicates:
                                                              false);
                                                        }
                                                      },
                                                      onChanged: (val) {
                                                        progressValue.value =
                                                            val.round();
                                                      },
                                                    ),
                                              ),*/
                                            ],
                                          ),
                                          // Bottom Items
                                          Container(
                                            margin: kMarginHorizontal,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                OutlinedButton(
                                                  onPressed: () {
                                                    Get.to(() =>
                                                        HistoryPage(
                                                          title: controller.init.user.value.wishes[index]
                                                          ['title'],
                                                          log: controller
                                                              .init
                                                              .user
                                                              .value
                                                              .wishes[index]
                                                          ['history'],
                                                        ));
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Text(
                                                        'U:${updateDate.year}-${updateDate
                                                            .month}-${updateDate.day}',
                                                        style: kTextStyleTaskSubtitle,
                                                      ),
                                                      Text(
                                                        'C:${creationDate.year}-${creationDate
                                                            .month}-${creationDate.day}',
                                                        style: kTextStyleTaskSubtitle,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  child: const Icon(EvaIcons.trashOutline),
                                                  //style: TextButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                                  onTap: () async {
                                                    Dialogs.materialDialog(context: context,
                                                    title: "delete_wish".tr,
                                                    msg: "cant_undone".tr,
                                                        // onClose: (val) {print("closed from $val");},
                                                        actions: [
                                                          IconsOutlineButton(
                                                            onPressed: () {
                                                              //Navigator.of(context, rootNavigator: true).pop();
                                                              Get.back();
                                                            },
                                                            text: 'cancel'.tr,
                                                            iconData: Icons.cancel_outlined,
                                                            textStyle: const TextStyle(color: Colors.grey),
                                                            iconColor: Colors.grey,
                                                          ),
                                                          IconsButton(
                                                            onPressed: () async {
                                                              Get.back();
                                                              await controller
                                                                  .deleteWish(index);
                                                              cardExpansionKeyList[index].currentState?.collapse();
                                                              await controller.init.user.refresh();
                                                              Get.offNamed(
                                                                  '/loggedin',
                                                                  preventDuplicates:
                                                                  false);

                                                            },
                                                            text: "delete".tr,
                                                            iconData: Icons.delete,
                                                            color: Colors.red,
                                                            textStyle: const TextStyle(color: Colors.white),
                                                            iconColor: Colors.white,
                                                          ),
                                                        ]

                                                    );

                                                  },
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  );
                                }
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
            RxList<Widget> moreData = <Widget>[].obs;
            RxBool showExtra = true.obs;
            Dialogs.materialDialog(context: context,
            dialogShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            title: "add_new_wish".tr,
              actions: [
                Obx(
                  () => Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      TextField(
                        onChanged: (value) => newWishInput = value,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                        decoration: InputDecoration(
                          hintText: "new_wish".tr,
                          contentPadding: const EdgeInsets.all(10),
                          border: kInputBorder,
                        ),
                      ),
                      Obx(
                        () => Column(
                          children: moreData,
                        ),
                      ),
                      showExtra.value? IconsOutlineButton(onPressed: () {
                        // Add custom data to new wish
                        moreData.add(
                          TextField(
                            controller: newWishStepsController,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                            onChanged: (value) {
                              newWishSteps = value;
                              var valueParsed = int.tryParse(newWishSteps);
                              print(valueParsed);
                              if(valueParsed==null){
                                newWishStepsController.text = '';
                                newWishSteps = '';
                              } else if(valueParsed > 256){
                                newWishStepsController.text = 'Oye tranquilo viejo';
                                newWishSteps = '';
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "new_steps".tr,
                              contentPadding: const EdgeInsets.all(5),
                              border: kInputBorder,
                            )
                        ),
                        );
                        showExtra.value = false;
                      }, text: "custom_data".tr, iconData: EvaIcons.plus) : const SizedBox(),
                      IconsOutlineButton(
                        onPressed: () async {
                          var valueParsed = int.tryParse(newWishSteps);
                          if(newWishInput == "") {
                            print("No title to new wish");
                            Get.back();
                            return;
                          }
                          if (valueParsed == null) {
                            newWishSteps = "100"; //default value
                            print("Steps not accepted. defaulting to 100");
                          }
                          await controller.newWish(newWishInput, newWishSteps);
                          await controller.loadWishes();
                          await controller.init.user.refresh();
                          Get.back();
                        },
                          text: "add_wish".tr
                      ),
                    ],
                  ),
                )
              ]

            );
            // Get.defaultDialog(
            //     title: 'Add new wish',
            //     content: TextField(
            //       onChanged: (value) => newWishInput = value,
            //     ),
            //     confirm: TextButton(
            //         onPressed: () async {
            //           await controller.newWish(newWishInput);
            //           await controller.loadWishes();
            //           await controller.init.user.refresh();
            //           Get.back();
            //         },
            //         child: const Text('Send')));
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
  int auxOld = oldIndex;
  int auxNew = newIndex;
  int operationValue = -1;

  // We can invert the limits (new and old indexes) to use the same for loop
  if (newIndex < oldIndex) {
    operationValue = 1; // for sum (or subtract) the index indicator of DB
    auxOld = newIndex;
    auxNew = oldIndex;
  }

  // We remove the initial item from list, then we set the new
  // index (the one used to track the custom user index on bd)
  // to the items affected
  var item = controller.init.user.value.wishes.removeAt(oldIndex);
  for (int i = auxOld; i < auxNew; i++) {
    controller.init.user.value.wishes[i]['indexAtUserList'] =
        controller.init.user.value.wishes[i]['indexAtUserList'] +
            operationValue;
  }
  // We set the new index to the item we removed from the list
  // and insert it again in the list at the new index
  item['indexAtUserList'] = newIndex;
  controller.init.user.value.wishes.insert(newIndex, item);
}

double sliderHPosAndConstraints(constraints, progressValue, maxSteps) {
  // Calculate H pos of slider in percentage in reference to max with of container
  // -4 because size of pill is 8 and this center it
  var calc = (constraints.maxWidth / maxSteps) * ((maxSteps - progressValue.value.toDouble())) + -4;
  double sliderSize = 8;
  if (calc > (constraints.maxWidth - sliderSize)) {
    return constraints.maxWidth - sliderSize;
  } else if (calc < 0) {
    return 0;
  } else {
    return calc;
  }
}

//Bug for some reason, it don't work as inline
/*
void onDragSliderUpdate(details, constraints,double valueOnStartDragProgress,RxInt progressValue) {
  // We read the progressValue settled when dragging started and use it to update
  // with current delta from last tick
  valueOnStartDragProgress = valueOnStartDragProgress + details.primaryDelta!;
  // We verify constrains
  double finalValue = valueOnStartDragProgress;
  if (valueOnStartDragProgress < 0) {
    finalValue = 0;
  }
  if (valueOnStartDragProgress > constraints.maxWidth) {
    finalValue = constraints.maxWidth;
  }
  progressValue.value = (finalValue / constraints.maxWidth * 100).toInt();
}

 */