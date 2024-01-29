import 'package:flutter/material.dart';

class ScaleNameWidget extends StatelessWidget {
  const ScaleNameWidget({
    super.key,
    required this.scaleImageUrl,
    required this.scaleName,
  });

  final String scaleImageUrl;
  final String scaleName;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          scaleName,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
          ),
        ),
        ClipRRect(
            borderRadius:
                BorderRadius.circular(15), // Adjust the radius as needed
            child: Image.asset(
              scaleImageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.fill, // Ensure the image covers the entire area
            )),
      ],
    );
  }
}
