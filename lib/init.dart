import 'package:flutter/widgets.dart';
import 'package:tablist_app/Models/user.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tablist_app/Data/user_data_bridge.dart';

import 'db_connection.dart';

class Init with WidgetsBindingObserver {

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
    WidgetsBinding.instance.addObserver(this);
    await Hive.initFlutter();
    _hiveDB = await Hive.openBox('UBL');
    _mongoDB = await DB().initDBConnection();
    if (_hiveDB?.get('isLoggedIn', defaultValue: false)) {
      String? savedUsername = _hiveDB?.get('username');
      if (savedUsername != null && savedUsername.isNotEmpty) {
        _user.value = await UserDataBridge(_mongoDB!).loadUser(savedUsername);
        // If user wasn't found in DB, reset login state
        if (_user.value.username.isEmpty) {
          _hiveDB?.put('isLoggedIn', false);
          _hiveDB?.put('username', '');
        }
      } else {
        // No valid username saved, reset login state
        _hiveDB?.put('isLoggedIn', false);
      }
    }
    await _registerServices();
    await _loadSettings();
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_mongoDB != null) {
        _mongoDB!.ensureConnected();
      }
    }
  }
}