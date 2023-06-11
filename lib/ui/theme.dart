import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myguide/ui/responsive_widget.dart';
import 'package:myguide/ui/spacers.dart';

const double _buttonHeight = 48;

extension TextThemeX on TextTheme {
  TextStyle get dL => displayLarge!;

  TextStyle get dM => displayMedium!;

  TextStyle get hL => headlineLarge!;

  TextStyle get hM => headlineMedium!;

  TextStyle get hS => headlineSmall!;

  TextStyle get tL => titleLarge!;

  TextStyle get tM => titleMedium!;

  TextStyle get tS => titleSmall!;

  TextStyle get bL => bodyLarge!;

  TextStyle get bM => bodyMedium!;

  TextStyle get bS => bodySmall!;
}

extension GreyColors on ColorScheme {
  Color get lightGrey => Colors.black12;

  Color get grey => Colors.black38;
}

class ApplicationTheme {
  static TextTheme _generateTextTheme(ColorScheme scheme) {
    return
      TextTheme(
        displayLarge: TextStyle(
          fontSize: 64,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: scheme.onBackground,
        ),
        displayMedium: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: scheme.onBackground,
        ),
        headlineLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: scheme.onBackground,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: scheme.onBackground,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: scheme.onBackground,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: scheme.onBackground,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: scheme.onBackground,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: scheme.onBackground,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          color: scheme.onBackground,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          color: scheme.onBackground,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          color: scheme.onBackground,
        ),

    );
  }

  static ThemeData data(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFD8533E),
      primary: const Color(0xFFD8533E),
      onSurface: const Color(0xFF1B201E),
      onBackground: const Color(0xFFDFDFD0),
      surface: const Color(0xFF000008),
      background: const Color(0xFF1A211F),
      tertiary: const Color(0xFFc9c9ad),
    );

    final textTheme = _generateTextTheme(colorScheme);

    return ThemeData(
      textTheme: textTheme,
      colorScheme: colorScheme,
      hintColor: colorScheme.grey,
      scaffoldBackgroundColor: colorScheme.background,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(_buttonHeight),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(_buttonHeight),
          shape: const RoundedRectangleBorder(
            side: BorderSide(),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.lightGrey,
        indent: AppSize.s,
        endIndent: AppSize.s,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: defaultTargetPlatform.when(
          context: context,
          mobile: true,
          desktop: false,
        ),
        titleSpacing: AppSize.m,
        backgroundColor: defaultTargetPlatform.when(
          context: context,
          mobile: colorScheme.surface,
          desktop: colorScheme.background,
        ),
        titleTextStyle: textTheme.hM.copyWith(color: colorScheme.onBackground),
        iconTheme: IconThemeData(
          color: colorScheme.onBackground,
          size: AppSize.m,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.surface,
        contentTextStyle: textTheme.tS.copyWith(color: colorScheme.onSurface),
      ),
      inputDecorationTheme: InputDecorationTheme(
        alignLabelWithHint: true,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        contentPadding: EdgeInsets.zero,
        fillColor: colorScheme.surface,
        hintStyle: textTheme.bM.copyWith(color: colorScheme.grey),
        labelStyle: textTheme.tS,
        errorStyle: textTheme.bS.copyWith(color: colorScheme.error),
        helperStyle: textTheme.bS.copyWith(color: colorScheme.grey),
        suffixStyle: textTheme.tS.copyWith(
          color: Colors.white,
          backgroundColor: Colors.black,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: colorScheme.grey),
          borderRadius: BorderRadius.zero,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: colorScheme.grey),
          borderRadius: BorderRadius.zero,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: colorScheme.onBackground),
          borderRadius: BorderRadius.zero,
        ),
      ),
    );
  }
}
