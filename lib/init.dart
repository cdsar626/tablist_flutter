import 'package:tablist_app/Models/User.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tablist_app/Data/user_data_bridge.dart';

import 'db_connection.dart';

class Init {

  DB? _mongoDB;
  Box<dynamic>? _hiveDB;
  final Rx<User> _user = User(
    '',
    '',
    DateTime.now(),
    DateTime.now(),
    [],
  ).obs;

  Future<void> initialize() async {
    await Hive.initFlutter();
    _hiveDB = await Hive.openBox('UBL');
    _mongoDB = await DB().initDBConnection();
    if (_hiveDB?.get('isLoggedIn', defaultValue: false)) {
      _user.value = await UserDataBridge(_mongoDB!).loadUser(_hiveDB?.get('username'));
    }
  }

  get mongoDB => _mongoDB;
  get hiveDB => _hiveDB;
  get user => _user;


  static _registerServices() async {
    //TODO register services

  }

  static _loadSettings() async {
    //TODO load settings
  }

}