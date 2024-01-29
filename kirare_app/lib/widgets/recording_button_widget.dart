import 'package:flutter/material.dart';
import 'package:pulsator/pulsator.dart';

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
    return GestureDetector(
      onTap: onRecord,
      child: Container(
        width: 150,
        height: 150,
        decoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.music_note,
          color: iconColor,
          size: 30,
        ),
      ),
    );
  }
}

class RecordingButtonWidget extends StatefulWidget {
  final bool isRecording;
  final VoidCallback onRecord;
  final Color? iconColor;

  const RecordingButtonWidget({
    super.key,
    required this.onRecord,
    required this.iconColor,
    required this.isRecording,
  });

  @override
  State<RecordingButtonWidget> createState() => _RecordingButtonWidgetState();
}

class _RecordingButtonWidgetState extends State<RecordingButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.isRecording
        ? LimitedBox(
            maxWidth: 300,
            maxHeight: 300,
            child: Pulsator(
              style: const PulseStyle(color: Colors.blue),
              count: 2,
              duration: const Duration(seconds: 4),
              startFromScratch: true,
              child: RecordingButton(
                onRecord: widget.onRecord,
                iconColor: widget.iconColor,
              ),
            ),
          )
        : RecordingButton(
            onRecord: widget.onRecord,
            iconColor: widget.iconColor,
          );
  }
}
