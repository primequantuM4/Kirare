import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kirare_app/data.dart';
import 'package:kirare_app/recording_button_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

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
  int elapsedTimeinSeconds = 0;
  Timer? recordingTimer;

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

  void startRecordingTimer() {
    recordingTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!isRecording) {
        timer.cancel();
      } else {
        setState(() {
          elapsedTimeinSeconds++;
        });
      }
    });
  }

  Future<void> startRecording() async {
    // await sendTestRequest();
    int randomNumber = Random().nextInt(100000) + Random().nextInt(200000);

    try {
      if (await audioRecord.hasPermission()) {
        String musicPath = await getDownloadsPath();
        await audioRecord.start(
          const RecordConfig(),
          path: "$musicPath/kirare_$randomNumber.wav",
        );

        setState(() {
          isRecording = true;
          elapsedTimeinSeconds = 0;
        });

        startRecordingTimer();

        await Future.delayed(const Duration(seconds: 32));
        await stopRecording();
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> stopRecording() async {
    print(isRecording);
    print("Has recorded: $elapsedTimeinSeconds seconds");
    try {
      final String? path = await audioRecord.stop();
      setState(() {
        isRecording = false;
        audioPath = path!;
        print(audioPath);
      });
      await sendAudio(path!, elapsedTimeinSeconds);
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
            onRecord: () async {
              if (isRecording) {
                await stopRecording();
              } else {
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
