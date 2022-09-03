import 'package:clean_bucket_list/Controllers/home_controller.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userInput = '';
    return NeumorphicApp(
      themeMode: ThemeMode.dark,
      home: Scaffold(
        appBar: NeumorphicAppBar(
          title: const Text('Simple yet Useful Bucket List'),
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
              NeumorphicButton(
                  onPressed: () async {
                    // Todo Login user
                    if (!await controller.userExists(userInput)) {
                      controller.createUser(userInput);
                    }
                    controller.init.hiveDB.put('username', userInput);
                    controller.init.hiveDB.put('isLoggedIn', true);
                    await controller.loadUser(userInput);
                    Get.offAndToNamed('/loggedin');
                  },
                  child: Text(
                      !controller.init.hiveDB.get('isLoggedIn', defaultValue: false)
                          ? 'log_in'.tr
                          : controller.getUser()?.value.username,
                    ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
