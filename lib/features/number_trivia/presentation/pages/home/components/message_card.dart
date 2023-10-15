import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  final String message;
  final Icon? icon;

  const MessageCard({
    super.key,
    required this.message,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          icon!,
          const SizedBox(height: 10),
        ],
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 25),
        ),
      ],
    );
  }
}
