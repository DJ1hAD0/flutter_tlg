// ignore: file_names
// ignore_for_file: file_names

import 'dart:io';
import 'package:nextcloud/nextcloud.dart';
import 'package:path_provider/path_provider.dart';

class NextCloudApi {
  final client = NextCloudClient.withCredentials(
    Uri(host: 'server'),
    'login',
    'password',
  );


  fileUpload()  async {

    await client.webDav
        .upload(File('test.jpg').readAsBytesSync(), '/test.png');
  }
}
