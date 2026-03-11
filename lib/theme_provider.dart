import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

void toggleThemeMode(WidgetRef ref) {
  final isDark = ref.read(themeModeProvider) == ThemeMode.dark;
  ref.read(themeModeProvider.notifier).state =
      isDark ? ThemeMode.light : ThemeMode.dark;
}

// Enhanced theme data
class AppThemes {
  // Light Theme Colors
  static const Color lightPrimary = Color(0xFFE53E3E);
  static const Color lightPrimaryVariant = Color(0xFFC53030);
  static const Color lightSecondary = Color(0xFF2D3748);
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightError = Color(0xFFE53E3E);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightOnBackground = Color(0xFF1A202C);
  static const Color lightOnSurface = Color(0xFF1A202C);
  static const Color lightOnError = Color(0xFFFFFFFF);

  // OLED-Friendly Dark Theme Colors
  static const Color darkPrimary = Color(0xFFFC8181);       // Accent (red-ish)
  static const Color darkPrimaryVariant = Color(0xFFFEB2B2);
  static const Color darkSecondary = Color(0xFFA0AEC0);

  static const Color darkBackground = Color(0xFF000000);    // Pure Black
  static const Color darkSurface = Color(0xFF121212);       // Dark Gray (for cards, surfaces)

  static const Color darkError = Color(0xFFFC8181);


  static const Color darkOnBackground = Color(0xFFE2E8F0);  // Light text on black
  static const Color darkOnSurface = Color(0xFFE2E8F0);
  static const Color darkOnPrimary = Color(0xFFFFFFFF);     // White text on red accent
  static const Color darkOnSecondary = Color(0xFFFFFFFF);   // White text on secondary
  static const Color darkOnError = Color(0xFFFFFFFF);       // White text on red error


  // Common Colors
  static const Color success = Color(0xFF48BB78);
  static const Color warning = Color(0xFFED8936);
  static const Color info = Color(0xFF4299E1);

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: lightPrimary,
        primaryContainer: lightPrimaryVariant,
        secondary: lightSecondary,
        surface: lightSurface,
        background: lightBackground,
        error: lightError,
        onPrimary: lightOnPrimary,
        onSecondary: lightOnSecondary,
        onSurface: lightOnSurface,
        onBackground: lightOnBackground,
        onError: lightOnError,
      ),
      scaffoldBackgroundColor: lightBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: lightSurface,
        foregroundColor: lightOnSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: lightOnSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        color: lightSurface,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightPrimary,
          foregroundColor: lightOnPrimary,
          elevation: 2,
          shadowColor: lightPrimary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: lightPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightError, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: TextStyle(color: Colors.grey.shade500),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: lightOnBackground,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: lightOnBackground,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: lightOnBackground,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: lightOnBackground,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: lightOnBackground,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: lightOnBackground,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        contentTextStyle: const TextStyle(color: lightOnPrimary),
        backgroundColor: lightSecondary,
        actionTextColor: lightPrimary,
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: darkPrimary,
        primaryContainer: darkPrimaryVariant,
        secondary: darkSecondary,
        surface: darkSurface,
        background: darkBackground,
        error: darkError,
        onPrimary: darkOnPrimary,
        onSecondary: darkOnSecondary,
        onSurface: darkOnSurface,
        onBackground: darkOnBackground,
        onError: darkOnError,
      ),
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: darkOnSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: darkOnSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        color: darkSurface,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: darkOnPrimary,
          elevation: 2,
          shadowColor: darkPrimary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade600),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade600),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkError, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: TextStyle(color: Colors.grey.shade400),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: darkOnBackground,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: darkOnBackground,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkOnBackground,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: darkOnBackground,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: darkOnBackground,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: darkOnBackground,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        contentTextStyle: const TextStyle(color: darkOnSurface),
        backgroundColor: darkSurface,
        actionTextColor: darkPrimary,
      ),
    );
  }
}
