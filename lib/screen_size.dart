import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

/// Default configuration for media query.
class ScreenSizeConfig {
  final double screenHeight;
  final double screenWidth;
  final double textInputWidth;
  final double textScale;

  ScreenSizeConfig({
    required this.screenHeight,
    required this.screenWidth,
    required this.textInputWidth,
    required this.textScale,
  });

  factory ScreenSizeConfig.screen({required context}) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    final screenHeight = mediaQueryData.size.height;
    final screenWidth = mediaQueryData.size.width;
    final textInputWidth = screenWidth * 0.75;
    final textScale = mediaQueryData.textScaleFactor;
    return ScreenSizeConfig(
      screenHeight: screenHeight,
      screenWidth: screenWidth,
      textInputWidth: textInputWidth,
      textScale: textScale,
    );
  }
}
