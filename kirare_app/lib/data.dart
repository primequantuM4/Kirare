import 'dart:async';
import 'package:http/http.dart' as http;

Future<void> sendAudio(String audioPath, int secondsDuration) async {
  String emulatorUrl = 'http://10.0.2.2:5000/upload-audio';
  String deviceUrl = 'http://192.168.45.134/upload-audio';

  print('Sending audio to $emulatorUrl, long long long long string');

  var request = http.MultipartRequest('POST', Uri.parse(emulatorUrl));
  request.fields['name'] = 'audio';
  request.fields['second_duration'] = secondsDuration.toString();

  final file = await http.MultipartFile.fromPath('audio', audioPath);
  request.files.add(file);

  try {
    var res = await request.send();
    var response = await http.Response.fromStream(res);

    if (res.statusCode == 200) {
      print(response.body);
    } else {
      print('Error: ${res.statusCode}');
    }
  } catch (e) {
    print(e);
  }
}
