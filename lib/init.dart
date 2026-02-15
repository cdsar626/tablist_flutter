<<<<<<< HEAD
import 'package:tablist_app/Models/user.dart';
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

=======
import 'package:tablist_app/Models/user.dart';
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

  DB? get mongoDB => _mongoDB;
  Box? get hiveDB => _hiveDB;
  Rx<User> get user => _user;


  static Future<void> _registerServices() async {
    //TODO register services

  }

  static Future<void> _loadSettings() async {
    //TODO load settings
  }

>>>>>>> 31280dec0883ba271a2c8b5fbde3c9ca558be329
}