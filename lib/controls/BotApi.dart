// ignore: file_names
// ignore_for_file: file_names

import 'package:flutter_tlg/model/Bot.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

class BotApi {
  late Bot bot;



  botInit() {
    var teledart = TeleDart(Telegram('КЛЮЧ'), Event('lis_telegram_bot'));
    bot = Bot();
    bot.teledart = teledart;
    bot.teledart.start();
    bot.teledart
        .onMessage(entityType: 'bot_command', keyword: 'start')
        .listen((message) {
      bot.msgId = message.chat.id;
    });
    return bot;
  }

  botSendMessage(String message) {
    if (bot.msgId != null) {
      bot.teledart.telegram.sendMessage(bot.msgId, message);
    }
  }

  botListenMessages(teledart) {
    teledart.onMessage().listen((message) {
      return message.text;
    });
  }
}
