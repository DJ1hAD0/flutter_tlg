// ignore: unused_import
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_tlg/controls/BotApi.dart';
import 'package:flutter_tlg/controls/NextCloudApi.dart';
import 'package:flutter_tlg/model/Bot.dart';
import 'package:flutter_tlg/view/MessageBubble.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  void renderMsg(text) {}
}

class _MyAppState extends State<MyApp> {
  late Bot mybot;
  late String senderName;
  late String msg;
  List<Map<String, dynamic>> _msgs = [];
  final _formKey = GlobalKey<FormState>();
  TextEditingController _fieldController = TextEditingController();
  MessageBubble _bubble = MessageBubble();
  String date = DateTime.now().toString().substring(0, 10);
  String photoUrl = '';

  @override
  void initState() {
    super.initState();
    BotApi().botInit().then((bot) {

      mybot = bot;
      mybot.teledart.onMessage().listen((message) {
        setState(() {
          senderName = message.chat.username.toString();
          _bubble.senderName = senderName;
          _bubble.msg = message.text;
          _bubble.orientation = false;

          String fullPath = '/lis_telegram_bot/' +
              message.chat.username.toString() +
              '-' +
              date +
              '/';

          if (message.photo != null) {
            NextCloudApi()
                .makeFolder(fullPath)
                .then((result) => BotApi().botSendMessage(mybot, result));
            for (var photo in message.photo) {
              bot.teledart.telegram.getFile(photo.file_id).then((file) {
                String fileName = DateTime.now().toString() +
                    '-' +
                    (file.file_path!.split('/').last);

                photoUrl = file.getDownloadLink(BotApi().token);

                NextCloudApi()
                    .fileUpload(photoUrl, fullPath, fileName)
                    .then((result) => BotApi().botSendMessage(mybot, result));
              });
            }
            _bubble.photoUrl = photoUrl;
            _bubble.msg = senderName + ' отправил фотографию';
          }

          _msgs.add({
            senderName: _bubble
          }); // message.text != null ? message.text : ''
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
                                  mainAxisAlignment:
                                      _msgs[index].keys.toList()[0] ==
                                              mybot.botName
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                  children: [
                                    Flexible(child: _bubble),
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
                                  BotApi().botSendMessage(
                                      mybot, _fieldController.text);
                                  setState(() {
                                    _bubble.senderName = mybot.botName;
                                    _bubble.msg = _fieldController.text;
                                    _bubble.orientation = true;
                                    _msgs.add({mybot.botName: _bubble});
                                    _fieldController.text = '';
                                  });
                                }
                              },
                              icon: Icon(Icons.send)),
                          labelText: 'Message',
                          hintText: 'Enter a text',

                          // icon: Icon(Icons.ac_unit),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.tealAccent, width: 0.0),
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
}
