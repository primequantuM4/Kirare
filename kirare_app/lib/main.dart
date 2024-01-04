import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
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

        // After recording for 31 seconds stop recording not 30 seconds
        if (elapsedTimeinSeconds > 30) {
          await stopRecording();
        }
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
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Center(
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
            ElevatedButton(
              onPressed: () => {print("I have restarted")},
              child: const Text("Check for restart"),
            )
          ],
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
