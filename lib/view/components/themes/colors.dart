import 'package:flutter/material.dart';

//IMPORTANT DON'T CHANGE THIS PROPERTY
double saturationStep = 0.05;
double lightnessStep = 0.2;
List<double> colorTintCoefficient = [1.8, 1.6, 1.4, 1.2, 1, 0.8, 0.6, 0.4, 0.2];

//First Determine The Brand Color

class MainColor {
  static String colorString = "#174BE8";
  static String stringColor = "0xFF${colorString.substring(1)}";
  static Color brandColor = Color(int.parse(stringColor));
  static double _hue = HSLColor.fromColor(brandColor).hue;
  static double _saturation = HSLColor.fromColor(brandColor).saturation;
  static double _lightness = HSLColor.fromColor(brandColor).lightness;

  static getColor(int index) {
    List<Color> _settledColor = [];
    List<Color> _tintCol = colorTintCoefficient.map((coef) {
      return _tintColor(brandColor, coef);
    }).toList();
    _settledColor.add(_tintColor(brandColor, 1.95));
    _settledColor.addAll(_tintCol);

    return _settledColor[index];
  }

  static Color _tintColor(Color col, double coef) {
    return HSLColor.fromColor(col)
        .withHue(_hue)
        .withSaturation(_saturation)
        .withLightness(_lightness * coef)
        .toColor();
  }
}



    



// HSLColor.fromAHSL(1, 271, 0.91, 0.49).toColor();
