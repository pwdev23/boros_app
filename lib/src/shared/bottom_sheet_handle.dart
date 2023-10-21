import 'package:flutter/material.dart';

class BottomSheetHandle extends StatelessWidget {
  const BottomSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    final disabledColor = Theme.of(context).disabledColor;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
      child: Container(
        width: kToolbarHeight,
        height: 3.0,
        decoration: BoxDecoration(
          color: disabledColor,
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
    );
  }
}
