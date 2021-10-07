// ignore: file_names
// ignore_for_file: file_names

import 'dart:typed_data';

import 'package:nextcloud/nextcloud.dart';
import 'package:http/http.dart' as http;

class NextCloudApi {


  final client = NextCloudClient.withCredentials(
    Uri(host: "HOST", path: "/cloud/"),
    'USERNAME',
    'PASSWORD',
  );

  makeFolder(fullpath) async {

    await client.webDav.mkdir(fullpath);

  }

  fileUpload(file_url, String localPath, String fileName) async {

    http.Response response = await http.get(Uri.parse(file_url));
    final Uint8List list = response.bodyBytes;
    await client.webDav.upload(list, localPath + fileName);
  }
}
