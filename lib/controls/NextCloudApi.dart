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



  fileUpload(file_url, String fname) async {

    http.Response response = await http.get(Uri.parse(file_url));
    final Uint8List list = response.bodyBytes; //Uint8List




   //ByteData bytes = await rootBundle.load(file_path);

   //final Uint8List list = bytes.buffer.asUint8List();

    await client.webDav
            .upload(list,'/lis_telegram_bot/'+fname);

  }
}
