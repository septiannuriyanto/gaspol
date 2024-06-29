import 'package:flutter/material.dart';
import 'package:gaspol/view/components/themes/colors.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData customTheme(Brightness brightness) {
  var baseTheme = ThemeData(
      brightness: brightness, useMaterial3: false, fontFamily: "Montserrat");
  return baseTheme.copyWith(
      buttonTheme: ButtonThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: MainColor.brandColor)));
}
