import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

final openAI = OpenAI.instance.build(
    token: kApiToken,
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
    isLog: true
);