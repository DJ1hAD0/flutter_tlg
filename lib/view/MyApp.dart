// ignore: unused_import
// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tlg/controls/BotApi.dart';
import 'package:flutter_tlg/model/Bot.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  void renderMsg(text) {}
}

class _MyAppState extends State<MyApp> {
  late Bot mybot;
  late String botName;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _fieldController = TextEditingController();
  List<Map<String, String>> _msgs = [];
  String msg = '';

  @override
  void initState() {
    super.initState();
    BotApi().botInit().then((bot) {
      mybot = bot;
      botName = bot.botName;
      mybot.teledart.onMessage().listen((message) {
        setState(() {
          _msgs.add({message.text: message.chat.username.toString()});
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Fetch Data Example',
        theme: ThemeData.dark(),
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Lis telegram bot'),
              actions: [],
            ),
            body: Column(
              children: [
                Center(
                    child: Column(children: [
                  Builder(builder: (BuildContext context) {
                    return Container(
                        height: MediaQuery.of(context).size.height / 4,
                        child: ListView.builder(
                            itemCount: _msgs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(children: [
                                Flexible(
                                    child: Text(
                                        '${_msgs.isNotEmpty ? _msgs[index] : ''}')),
                              ]);
                            }));
                  })
                ])),
                SizedBox(height: 20.0),
                Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _fieldController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Type a text';
                        }
                        return value;
                      },
                    )),
                IconButton(
                    onPressed: (){
                                BotApi().botSendMessage(mybot, _fieldController.text);
                                setState(() {
                                  _msgs.add({botName : _fieldController.text});
                                });

                    },
                    icon: Icon(Icons.send))
              ],
            )));
  }

}
