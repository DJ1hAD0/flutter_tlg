// ignore: file_names
// ignore_for_file: file_names

import 'package:flutter_tlg/controls/NextCloudApi.dart';
import 'package:flutter_tlg/model/Bot.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

class BotApi {
  late Bot bot;
  String msg = '';
  final String token = 'TOKEN';


  botInit() async {
    bot = Bot();
    bot.telegram = Telegram(token);
    bot.botName = (await bot.telegram.getMe()).username!;
    bot.event = Event(bot.botName);
    bot.teledart = TeleDart(bot.telegram, bot.event);
    bot.teledart.start();

    bot.teledart
        .onMessage(entityType: 'bot_command', keyword: 'start')
        .listen((message) {
      bot.msgId = message.chat.id;
      botSendMessage(bot,'BOT INIT SUCCESS! CHAT_ID = ' + bot.msgId.toString());

     /* bot.teledart.telegram.sendMessage(message.chat.id,
          'BOT INIT SUCCESS! CHAT_ID = ' + bot.msgId.toString());*/
    });

    return bot;
  }

  botSendMessage(Bot bot, String message) {
    if (bot.msgId != null) {
      bot.teledart.telegram.sendMessage(bot.msgId, message);
    }
  }
}
