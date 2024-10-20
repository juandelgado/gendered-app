import 'package:flutter/material.dart';

// class AppColors {
//   static const Color top = Color(0xffFFA296);
//   static const Color middle = Color(0xFFFFB627);
//   static const Color bottom = Color(0xffcc5803);
//   static const Color lightBackground = Color(0xFFFFB627);
//   static const Color darkBackground = Color(0xff2a2d43);
// }

class AppThemes {
  // https://api.flutter.dev/flutter/material/ColorScheme/ColorScheme.dark.html#material.ColorScheme.dark.1
  static final darkTheme = ThemeData(
    fontFamily: 'OutfitRegular',
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xffbb86fc),
      brightness: Brightness.dark,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    ).copyWith(
      primaryContainer: const Color(0xffbb86fc),
      onPrimaryContainer: Colors.black,
      secondaryContainer: const Color(0xff03dac6),
      onSecondaryContainer: Colors.black,
      error: const Color(0xffcf6679),
      onError: Colors.black,
    ),
    useMaterial3: true,
  );

  static final lightTheme = ThemeData(
    fontFamily: 'OutfitRegular',
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.amberAccent,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    ),
    useMaterial3: true,
  );
}
