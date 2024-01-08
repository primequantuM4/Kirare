
import 'package:flutter/material.dart';

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
