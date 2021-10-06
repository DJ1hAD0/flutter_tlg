// ignore: file_names
// ignore_for_file: file_names

import 'package:flutter_tlg/controls/NextCloudApi.dart';
import 'package:flutter_tlg/model/Bot.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

class BotApi {
  late Bot bot;
  String msg = '';


  botInit() async {
    var telegram = Telegram('API_KEY');
    var event = Event((await telegram.getMe()).username!);
    var teledart = TeleDart(telegram, event);
    bot = Bot();
    bot.teledart = teledart;
    bot.teledart.start();
    bot.botName = (await telegram.getMe()).username!;

    bot.teledart
        .onMessage(entityType: 'bot_command', keyword: 'start')
        .listen((message) {
      bot.msgId = message.chat.id;
      teledart.telegram.sendMessage(message.chat.id, 'Bot init success!');

    });
    bot.teledart
        .onMessage(entityType: 'bot_command', keyword: 'upload')
        .listen((message) {
      NextCloudApi().fileUpload();
      teledart.telegram.sendMessage(message.chat.id, 'Photo uploaded');

    });
    return bot;
  }

  botSendMessage(Bot bot, String message) {
    if (bot.msgId != null) {
      bot.teledart.telegram.sendMessage(bot.msgId, message);
    }
  }


}
