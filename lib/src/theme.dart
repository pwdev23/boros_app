import 'package:flutter/material.dart';

const kSeedColor = Color(0xff004af6);

final theme = ThemeData.light(useMaterial3: true).copyWith(
    colorScheme: ColorScheme.fromSeed(
  seedColor: kSeedColor,
  brightness: Brightness.light,
));

final darkTheme = ThemeData.dark(useMaterial3: true).copyWith(
    colorScheme: ColorScheme.fromSeed(
  seedColor: kSeedColor,
  brightness: Brightness.dark,
));
