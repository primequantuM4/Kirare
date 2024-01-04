import 'dart:io';

import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const KirareApp());
}

class KirareApp extends StatefulWidget {
  const KirareApp({super.key});

  @override
  State<KirareApp> createState() => _KirareAppState();
}

class _KirareAppState extends State<KirareApp> {
  late final AudioRecorder audioRecord;
  bool isRecording = false;
  String audioPath = '';

  Future<String> getDownloadsPath() async {
    Directory? downloadsDirectory = await getDownloadsDirectory();
    return downloadsDirectory!.path;
  }

  @override
  void initState() {
    audioRecord = AudioRecorder();
    super.initState();
  }

  @override
  void dispose() {
    audioRecord.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        String musicPath = await getDownloadsPath();
        await audioRecord.start(const RecordConfig(), path: "$musicPath/x.wav");

        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> stopRecording() async {
      print(isRecording);
    try {
      final String? path = await audioRecord.stop();
      setState(() {
        isRecording = false;
        audioPath = path!;
        print(audioPath);
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: RecordingButton(
            onRecord: () async{
                if (isRecording){
                    await stopRecording();
                }else{
                    await startRecording();
                }
            },
            iconColor: isRecording ? Colors.red : Colors.white,
          ),
        ),
      ),
    );
  }
}

class RecordingButton extends StatelessWidget {
  final VoidCallback onRecord;
  final Color? iconColor;

  const RecordingButton({
    super.key,
    required this.onRecord,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onRecord,
      padding: const EdgeInsets.all(75),
      fillColor: Colors.blue,
      elevation: 5.0,
      shape: const CircleBorder(),
      child: Icon(
        Icons.music_note,
        color: iconColor,
        size: 30,
      ),
    );
  }
}
