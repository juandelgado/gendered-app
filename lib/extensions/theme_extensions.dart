import 'package:flutter/material.dart';

// https://api.flutter.dev/flutter/material/TextTheme-class.html
extension TextThemeX on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}

// https://api.flutter.dev/flutter/material/ColorScheme-class.html
extension ColorSchemeX on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
