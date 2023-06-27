import 'package:flutter/material.dart';

extension BuildContextColors on BuildContext {
  Color dynamicPlainColor({
    required Color lightThemeColor,
    required Color darkThemeColor,
  }) {
    final brightness = MediaQuery.of(this).platformBrightness;

    switch (brightness) {
      case Brightness.light:
        return lightThemeColor;
      case Brightness.dark:
        return darkThemeColor;
    }
  }
}