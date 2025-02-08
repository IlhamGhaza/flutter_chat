// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AuthProm extends StatelessWidget {
  final VoidCallback onPressed;
  final String text1;
  final String text2;
  const AuthProm({
    super.key,
    required this.onPressed,
    required this.text1,
    required this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text1),
        TextButton(
          onPressed: onPressed,
          child: Text(text2),
        ),
      ],
    );
  }
}
