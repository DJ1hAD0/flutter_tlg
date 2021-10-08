// ignore: file_names
// ignore_for_file: file_names

import 'dart:typed_data';

import 'package:nextcloud/nextcloud.dart';
import 'package:http/http.dart' as http;

class NextCloudApi {
  final client = NextCloudClient.withCredentials(
    Uri(host: "HOST", path: "/cloud/"),
    'USER',
    'PASSWORD',
  );

  makeFolder(fullpath) async {
    try {
      await client.webDav.mkdir(fullpath);
    } on RequestException catch (e) {
      return 'Ошибка создания папки: ' +
          e.statusCode.toString() +
          e.body.toString();
    }
    return '--------------------';
  }

  fileUpload(file_url, String localPath, String fileName) async {
    http.Response response = await http.get(Uri.parse(file_url));
    final Uint8List list = response.bodyBytes;
    try {
      await client.webDav.upload(list, localPath + fileName);
    } on RequestException catch (e) {
      return 'Ошибка загрузки файла: ' +
          e.statusCode.toString() +
          e.body.toString();
    }
    return 'Файл успешно загружен в облако!';
  }
}
