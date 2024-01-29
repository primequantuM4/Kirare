import 'package:flutter/material.dart';

class CustomTextDescription extends StatelessWidget {
  const CustomTextDescription({
    super.key,
    required this.description,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Text(
        description,
        textAlign: TextAlign.left,
      ),
    );
  }
}
