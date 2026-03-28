import 'package:flutter/material.dart';

extension ResponsiveExt on BuildContext {

  //  Design Base (Figma)


  static const double designWidth = 411;
  static const double designHeight = 884;

  //  Device Info

  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  Orientation get orientation => MediaQuery.of(this).orientation;

  bool get isTablet => screenWidth >= 600;


  //  Scaling Factor

  double get _scaleWidth => screenWidth / designWidth;
  double get _scaleHeight => screenHeight / designHeight;

  double get _scale => (_scaleWidth + _scaleHeight) / 2;

  //  Responsive Width

  double w(double value) {
    final scaled = value * _scaleWidth;
    return scaled.clamp(value * 0.8, value * 1.4);
  }


  //  Responsive Height


  double h(double value) {
    final scaled = value * _scaleHeight;
    return scaled.clamp(value * 0.8, value * 1.4);
  }


  //  Radius


  double r(double value) {
    final scaled = value * _scale;
    return scaled.clamp(value * 0.8, value * 1.5);
  }

  //  Font Size Smart Scaling

  double sp(double value) {
    final scaleFactor = _scale;
    final scaled = value * scaleFactor;

    // لو جهاز كبير جدًا نثبت الحجم
    if (isTablet) {
      return value * 1.1;
    }

    return scaled.clamp(value * 0.85, value * 1.3);
  }

  //  Spacing Helper


  SizedBox verticalSpace(double value) =>
      SizedBox(height: h(value));

  SizedBox horizontalSpace(double value) =>
      SizedBox(width: w(value));
}