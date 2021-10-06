// ignore: unused_import
// ignore_for_file: file_names

import 'dart:ffi';
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
  late String userName;

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
          userName = message.chat.username.toString();
          _msgs.add({userName: message.text});
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
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: ListView.builder(
                            itemCount: _msgs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                  mainAxisAlignment: _msgAlign(index),
                                  children: [
                                    Flexible(
                                      child: Container(
                                        margin: const EdgeInsets.all(15.0),
                                        padding: const EdgeInsets.all(3.0),
                                        decoration: BoxDecoration(
                                            color: Colors.white10,
                                            border: Border.all(
                                                color: Colors.tealAccent),
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: _msgs[index]
                                                          .keys
                                                          .toList()[0] ==
                                                      botName
                                                  ? Radius.circular(22.0)
                                                  : Radius.circular(0),
                                              bottomRight: _msgs[index]
                                                          .keys
                                                          .toList()[0] ==
                                                      botName
                                                  ? Radius.circular(0.0)
                                                  : Radius.circular(22.0),
                                              topRight: Radius.circular(22.0),
                                              topLeft: Radius.circular(22.0),
                                            )
                                            /*borderRadius: BorderRadius.all(
                                              Radius.circular(30.0)),*/
                                            ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                '${_msgs.isNotEmpty ? _msgs[index].values.first : ''}',
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10.0, 10.0, 50.0, 10.0),
                                              child: Text(
                                                '${_msgs.isNotEmpty ? _msgs[index].keys.first : ''}',
                                                style: TextStyle(
                                                    fontSize: 10.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.tealAccent),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]);
                            }));
                  })
                ])),
                SizedBox(height: 20.0),
                Form(
                        key: _formKey,
                        child: TextFormField(
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      BotApi().botSendMessage(mybot, _fieldController.text);
                                      setState(() {
                                        _msgs.add({botName: _fieldController.text});
                                        _fieldController.text = '';
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.send)),
                              labelText: 'Message',
                              hintText: 'Enter a text',

                              // icon: Icon(Icons.ac_unit),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.tealAccent, width: 0.0),
                                borderRadius: BorderRadius.circular(10.0),


                              )),
                          controller: _fieldController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Type a text';
                            }
                          },
                        )),
                    /**/

              ],
            )));
  }

  _msgAlign(index) {
    if (_msgs[index].keys.toList()[0] == botName) {
      return MainAxisAlignment.end;
    } else {
      return MainAxisAlignment.start;
    }
  }
}
