import 'package:flutter/material.dart';

const kSeedColor = Color(0xff004af6);

final theme = ThemeData.light().copyWith(
    colorScheme: ColorScheme.fromSeed(
  seedColor: kSeedColor,
  brightness: Brightness.light,
));

final darkTheme = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.fromSeed(
  seedColor: kSeedColor,
  brightness: Brightness.dark,
));
