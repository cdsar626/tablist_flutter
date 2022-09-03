import 'package:clean_bucket_list/Bindings/loggedin_bindings.dart';
import 'package:clean_bucket_list/View/Pages/logged_in.dart';
import 'package:clean_bucket_list/init.dart';
import 'package:clean_bucket_list/splash_screen.dart';
import 'package:clean_bucket_list/translations.dart';
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
          ],
        );
      } else {
        return const SplashScreen();
      }


    },
  ));

}


