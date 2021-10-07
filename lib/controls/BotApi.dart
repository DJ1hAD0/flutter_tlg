// ignore: file_names
// ignore_for_file: file_names

import 'package:flutter/services.dart';
import 'package:flutter_tlg/controls/NextCloudApi.dart';
import 'package:flutter_tlg/model/Bot.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

class BotApi {
  late Bot bot;
  String msg = '';

  botInit() async {
    final String token = 'TOKEN';

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
      bot.teledart.telegram.sendMessage(message.chat.id,
          'BOT INIT SUCCESS! CHAT_ID = ' + bot.msgId.toString());
    });

    bot.teledart.onMessage().listen((message) {
      if (message.photo != null) {
        for (var photo in message.photo) {
          bot.teledart.telegram.getFile(photo.file_id).then((file) {
            //print(file.getDownloadLink(token));
            var fileName = photo.file_id + (file.file_path!.split('/').last);

            NextCloudApi().fileUpload(file.getDownloadLink(token), fileName);
          });
        }
      }

      bot.teledart.telegram.sendMessage(message.chat.id, 'recieved a photo');
    });

    bot.teledart
        .onMessage(entityType: 'bot_command', keyword: 'upload')
        .listen((message) {
      //NextCloudApi().fileUpload();
      bot.teledart.telegram.sendMessage(message.chat.id, 'Photo uploaded');
    });
    return bot;
  }

  botSendMessage(Bot bot, String message) {
    if (bot.msgId != null) {
      bot.teledart.telegram.sendMessage(bot.msgId, message);
    }
  }
}
