import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:tablist_app/Controllers/history_controller.dart';
import 'package:get/get.dart';
import 'package:tablist_app/Models/status_item_wl.dart';
import 'package:intl/intl.dart';

class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({Key? key, required this.title, required this.log})
      : super(key: key);

  final List log;
  final String title;

  @override
  Widget build(BuildContext context) {
    int skipIndex = 0;
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(EvaIcons.arrowLeft),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: ListView.builder(
            itemCount: log.length,
            reverse: true,
            itemBuilder: (context, index) {
              if (skipIndex > 0) {
                skipIndex--;
                return const SizedBox();
              }
              // int inverseIndex = log.length - index - 1;
              var info = getStatusProgWhen(index);
              String? status = info.elementAt(0);
              String progressNum = info.elementAt(1);
              DateTime when = info.elementAt(2);
              List<ActionRowOfDayHistory> rowsOfActions = [];
              rowsOfActions
                  .add(ActionRowOfDayHistory(status, progressNum, when));
              while (index + 1 < log.length) {
                if (when.day == log[index + 1]['when'].toLocal().day) {
                  index++;
                  skipIndex++;
                  info = getStatusProgWhen(index);
                  status = info.elementAt(0);
                  progressNum = info.elementAt(1);
                  when = info.elementAt(2);
                  rowsOfActions
                      .add(ActionRowOfDayHistory(status, progressNum, when));
                } else {
                  return CardHistory(when, rowsOfActions);
                }
              }
              return CardHistory(when, rowsOfActions);
            }),
      ),
    ));
  }

  Set<dynamic> getStatusProgWhen(int index) {
    DateTime when = log[index]['when'].toLocal();
    String progressNum = log[index]['progress'].round().toString();
    var status = log[index]['status'];
    if (log[index]['status'] == StatusItemWL.active.index) {
      status = 'Active';
    } else if (log[index]['status'] == StatusItemWL.paused.index) {
      status = 'Paused';
    } else if (log[index]['status'] == StatusItemWL.abandoned.index) {
      status = 'Abandoned';
    } else if (log[index]['status'] == StatusItemWL.completed.index) {
      status = 'Completed';
    }
    return {status, progressNum, when};
  }
}

class CardHistory extends StatelessWidget {
  final DateTime when;
  final List<ActionRowOfDayHistory> rowsOfActions;
  const CardHistory(this.when, this.rowsOfActions, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      // Single Day
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat('yyyy-MM-dd').format(when.toLocal()).toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                )),
            const SizedBox(
              height: 5.0,
            ),
            Column(
              children: rowsOfActions.reversed.toList(),
            )
          ],
        ),
      ),
    );
  }
}

class ActionRowOfDayHistory extends StatelessWidget {
  final String? status;
  final String progressNum;
  final DateTime when;

  const ActionRowOfDayHistory(
    this.status,
    this.progressNum,
    this.when, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(status == null
              ? "historyProgressUpdate".trParams({
                  'progress': progressNum,
                })
              : "historyStatusUpdate".trParams({
                  'status': status ?? 'error',
                })),
          Text(
            DateFormat('HH:mm').format(when.toLocal()).toString(),
            style: const TextStyle(
              //fontSize: 12.0,
              fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }
}

class HistoryLine1 extends StatelessWidget {
  final List<dynamic> log;
  final int index;
  final String? status;

  const HistoryLine1(
    this.log,
    this.index,
    this.status, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black87,
          ),
          width: 10.0,
          height: 10.0,
        ),
        Container(
          child: log[index]['status'] != null
              ? Text('historyStatusUpdate'.trParams({
                  'status': status.toString(),
                }))
              : Text('historyProgressUpdate'.tr),
        )
      ],
    );
  }
}
