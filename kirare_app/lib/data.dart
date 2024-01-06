import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

Future<void> sendAudio(String audioPath) async {
  String emulatorUrl = 'http://10.0.2.2:5000/upload-audio';
  String deviceUrl = 'http://192.168.1.5:5000/upload-audio';

  var request = http.MultipartRequest('POST', Uri.parse(emulatorUrl));
  request.fields['name'] = 'audio';

  final file = await http.MultipartFile.fromPath('audio', audioPath);
  request.files.add(file);

  try {
    var res = await request.send();
    if (res.statusCode == 200) {
      print('Uploaded!');
    } else {
      print('Not Uploaded!');
    }
  } catch (e) {
    print(e);
  }
}
