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
}

class _MyAppState extends State<MyApp> {
  Bot mybot = BotApi().botInit();

  final _formKey = GlobalKey<FormState>();
  TextEditingController _fieldController = TextEditingController();
  List<Map<String, String>> _msgs = [];
  String msg = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Fetch Data Example',
        theme: ThemeData.dark(),
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Lis telegram bot'),
              actions: [
                IconButton(
                  onPressed: () => _botStart(mybot.teledart),
                  icon: Icon(Icons.ac_unit),
                )
              ],
            ),
            body: Column(
              children: [
                Center(
                    child: Column(children: [
                  Builder(builder: (BuildContext context) {
                    return Container(
                        height: MediaQuery.of(context).size.height / 1.8,
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
                    onPressed: () =>
                        BotApi().botSendMessage(mybot, _fieldController.text),
                    icon: Icon(Icons.send))
              ],
            )));
  }

  _botStart(Bot mybot) async {
    msg = BotApi().botListenMessages(mybot.teledart);
    print(msg);
  }
}
