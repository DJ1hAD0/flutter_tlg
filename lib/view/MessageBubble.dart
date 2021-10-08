// ignore: file_names
// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageBubble extends StatelessWidget {
  String senderName = '';
  bool orientation = false;
  String? msg = '';
  String photoUrl = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
          color: Colors.white10,
          border: Border.all(color: Colors.tealAccent),
          borderRadius: BorderRadius.only(
            bottomLeft:
                orientation ? Radius.circular(22.0) : Radius.circular(0),
            bottomRight:
                orientation ? Radius.circular(0.0) : Radius.circular(22.0),
            topRight: Radius.circular(22.0),
            topLeft: Radius.circular(22.0),
          )
          /*borderRadius: BorderRadius.all(
                                              Radius.circular(30.0)),*/
          ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              msg!,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
            ),
          ),
          GestureDetector(
              child: Text(photoUrl != '' ? 'Ссылка' : '',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue)),
              onTap: () {
                _launchURL();
              }),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 50.0, 10.0),
            child: Text(
              senderName,
              style: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.tealAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL() async => await canLaunch(photoUrl)
      ? await launch(photoUrl)
      : throw 'Could not launch $photoUrl';
}
