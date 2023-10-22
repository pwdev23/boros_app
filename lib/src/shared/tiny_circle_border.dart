import 'package:flutter/material.dart';

class TinyCircleBorder extends StatelessWidget {
  const TinyCircleBorder({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.inverseSurface,
      ),
      child: Text(text, style: TextStyle(color: colorScheme.onInverseSurface)),
    );
  }
}
