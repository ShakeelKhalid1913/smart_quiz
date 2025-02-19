import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Light Theme Colors
  static final ColorScheme lightColorScheme = ColorScheme.light(
    primary: const Color(0xFF6200EE),
    secondary: const Color(0xFF03DAC6),
    surface: const Color(0xFFF5F5F5),
    surfaceContainerHighest: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: const Color(0xFF1D1D1D),
  );

  // Dark Theme Colors
  static final ColorScheme darkColorScheme = ColorScheme.dark(
    primary: const Color(0xFFBB86FC),
    secondary: const Color(0xFF03DAC6),
    surface: const Color(0xFF121212),
    surfaceContainerHighest: const Color(0xFF1E1E1E),
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.white,
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: lightColorScheme.surface,
    cardTheme: CardTheme(
      color: lightColorScheme.surfaceContainerHighest,
      elevation: 2,
      margin: EdgeInsets.zero,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: lightColorScheme.primary,
      foregroundColor: lightColorScheme.onPrimary,
      elevation: 0,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: darkColorScheme.surface,
    cardTheme: CardTheme(
      color: darkColorScheme.surfaceContainerHighest,
      elevation: 2,
      margin: EdgeInsets.zero,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
    appBarTheme: AppBarTheme(
      backgroundColor: darkColorScheme.surface,
      foregroundColor: darkColorScheme.onSurface,
      elevation: 0,
    ),
  );
}
