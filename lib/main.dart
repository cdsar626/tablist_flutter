import 'package:tablist_app/Bindings/history_bindings.dart';
import 'package:tablist_app/Bindings/loggedin_bindings.dart';
import 'package:tablist_app/View/Pages/history.dart';
import 'package:tablist_app/View/Pages/logged_in.dart';
import 'package:tablist_app/init.dart';
import 'package:tablist_app/splash_screen.dart';
import 'package:tablist_app/translations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Bindings/home_bindings.dart';
import 'View/Pages/home.dart';

void main() async{
  var init = Init();
  runApp(FutureBuilder(
    future: init.initialize(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done){
        return GetMaterialApp(
          locale: const Locale('en'),
          translations: AppTranslations(),
          initialRoute: init.user.value.username == ''? '/home' : '/loggedin',
          getPages: [
            GetPage(name: '/home', page: () => const HomePage(), binding: HomeBinding(init)),
            GetPage(name: '/loggedin', page: () => const LoggedInPage(), binding: LoggedInBinding(init)),
            GetPage(name: '/history', page: () => const HistoryPage(log: [], title: ""), binding: HistoryBinding(init)),
          ],
        );
      } else {
        return const SplashScreen();
      }


    },
  ));

}


