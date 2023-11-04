import 'package:flutter/material.dart';

class InfoTextBox extends StatelessWidget {
  const InfoTextBox({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              children: [
                Text(
                  text,
                  style: textTheme.bodySmall!
                      .copyWith(color: colorScheme.onPrimaryContainer),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
