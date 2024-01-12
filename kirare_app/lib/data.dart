import 'dart:async';
import 'package:http/http.dart' as http;

Future<String> sendAudio(String audioPath, int secondsDuration) async {
  String emulatorUrl = 'http://10.0.2.2:5000/upload-audio';
  String deviceUrl = 'http:///upload-audio';

  print('Sending audio to $emulatorUrl, long long long long string');

  var request = http.MultipartRequest('POST', Uri.parse(emulatorUrl));
  request.fields['name'] = 'audio';
  request.fields['second_duration'] = secondsDuration.toString();

  final file = await http.MultipartFile.fromPath('audio', audioPath);
  request.files.add(file);

  try {
    var res = await request.send();
    var response = await http.Response.fromStream(res);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to upload audio');
    }
  } catch (e) {
    throw Exception('Failed to upload audio');
  }
}

// for debugging purposes
Future<void> sendTestRequest() async {
  String baseUrl = 'http://192.168.125.134:5000/hello';

  try {
    var testRequest = await http.get(Uri.parse(baseUrl));
    if (testRequest.statusCode == 200) {
      print("${testRequest.body} and so much more is there to the world and stuff");
    }

  } catch (e) {
    print(e);
  }
}
