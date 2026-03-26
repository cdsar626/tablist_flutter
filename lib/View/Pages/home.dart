import 'package:flutter/material.dart';
import 'package:tablist_app/Controllers/home_controller.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String userInput = '';
    return MaterialApp(
      themeMode: ThemeMode.dark,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TABList'),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: 'username'.tr,
                  ),
                  onChanged: (val) {
                    userInput = val;
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (userInput.trim().isEmpty) return;
                    // Create user if it doesn't exist
                    if (!await controller.userExists(userInput)) {
                      await controller.createUser(userInput);
                    }
                    // Await Hive puts so state is persisted before navigation
                    await controller.init.hiveDB?.put('username', userInput);
                    await controller.init.hiveDB?.put('isLoggedIn', true);
                    await controller.loadUser(userInput);
                    // Verify user was loaded successfully before navigating
                    if (controller.getUser()?.value.username.isNotEmpty ?? false) {
                      Get.offAndToNamed('/loggedin');
                    }
                  },
                  child: Text(
                      !controller.init.hiveDB?.get('isLoggedIn', defaultValue: false)
                          ? 'log_in'.tr
                          : controller.getUser()!.value.username,
                    ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
