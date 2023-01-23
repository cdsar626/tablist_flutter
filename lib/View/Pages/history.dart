import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:tablist_app/Controllers/history_controller.dart';
import 'package:get/get.dart';
import 'package:tablist_app/Models/status_item_wl.dart';

class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({Key? key, required this.log}) : super(key: key);

  final List log;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('TABList'),
            leading: IconButton(
              icon: const Icon(EvaIcons.arrowLeft), onPressed: () { Get.back(); },
            ),
          ),
          body: Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: ListView.builder(
                itemCount: log.length,
                itemBuilder: (context, index) {
                  int inverseIndex = log.length - index - 1;
                  DateTime when = log[inverseIndex]['when'];
                  var status = log[inverseIndex]['status'];
                  if (log[inverseIndex]['status'] ==
                      StatusItemWL.active.index) {
                    status = 'Active';
                  } else if (log[inverseIndex]['status'] ==
                      StatusItemWL.paused.index) {
                    status = 'Paused';
                  } else if (log[inverseIndex]['status'] ==
                      StatusItemWL.abandoned.index) {
                    status = 'Abandoned';
                  } else if (log[inverseIndex]['status'] ==
                      StatusItemWL.completed.index) {
                    status = 'Completed';
                  }
                  return Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        HistoryLine1(log, inverseIndex, status),
                        Container(
                          margin: const EdgeInsets.only(bottom: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                    'progress'.trParams({
                                      'num':log[inverseIndex]['progress'].round().toString()
                                    }),
                                  )),
                              Container(
                                  alignment: Alignment.centerRight,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                      '${when.year}-${when.month}-${when.day}')),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ),
        ));
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
