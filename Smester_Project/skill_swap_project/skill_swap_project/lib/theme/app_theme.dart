import 'package:flutter/material.dart';

class AppTheme {
  // =========================================================
  // LIGHT THEME
  // =========================================================
  static ThemeData lightTheme() {
    const primaryColor = Color(0xFF2563EB);

    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
        ).copyWith(
          primary: primaryColor,
          secondary: const Color(0xFF60A5FA),
          tertiary: const Color(0xFFBFDBFE),

          surface: Colors.white,
          onSurface: const Color(0xFF0F172A),

          primaryContainer: const Color(0xFFDCEBFF),
          secondaryContainer: const Color(0xFFEAF4FF),

          outline: const Color(0xFFE2E8F0),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,

      // =========================================================
      // BACKGROUND
      // =========================================================
      scaffoldBackgroundColor: const Color(0xFFF4F8FF),

      // =========================================================
      // APP BAR
      // =========================================================
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF0F172A),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,

        titleTextStyle: TextStyle(
          color: Color(0xFF0F172A),
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),

        iconTheme: IconThemeData(color: Color(0xFF0F172A)),
      ),

      // =========================================================
      // CARD
      // =========================================================
      cardTheme: CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        margin: EdgeInsets.zero,
      ),

      // =========================================================
      // DIALOG
      // =========================================================
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      // =========================================================
      // INPUT
      // =========================================================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),

        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),

        labelStyle: const TextStyle(
          color: Color(0xFF475569),
          fontWeight: FontWeight.w500,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),

          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),

          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),

          borderSide: const BorderSide(color: primaryColor, width: 1.6),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),

          borderSide: const BorderSide(color: Colors.red),
        ),
      ),

      // =========================================================
      // ELEVATED BUTTON
      // =========================================================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,

          minimumSize: const Size(double.infinity, 54),

          elevation: 0,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),

          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      // =========================================================
      // OUTLINED BUTTON
      // =========================================================
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,

          side: const BorderSide(color: Color(0xFFD6E4FF)),

          minimumSize: const Size(double.infinity, 54),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      // =========================================================
      // CHIP
      // =========================================================
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFEAF4FF),

        selectedColor: primaryColor,

        disabledColor: const Color(0xFFE2E8F0),

        labelStyle: const TextStyle(
          color: Color(0xFF2563EB),
          fontWeight: FontWeight.w600,
        ),

        secondaryLabelStyle: const TextStyle(color: Colors.white),

        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      // =========================================================
      // BOTTOM NAVIGATION
      // =========================================================
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,

        selectedItemColor: primaryColor,
        unselectedItemColor: Color(0xFF94A3B8),

        elevation: 0,

        type: BottomNavigationBarType.fixed,
      ),

      // =========================================================
      // DIVIDER
      // =========================================================
      dividerColor: const Color(0xFFE2E8F0),

      // =========================================================
      // TEXT
      // =========================================================
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Color(0xFF0F172A),
          fontWeight: FontWeight.bold,
        ),

        titleLarge: TextStyle(
          color: Color(0xFF0F172A),
          fontWeight: FontWeight.w700,
        ),

        titleMedium: TextStyle(
          color: Color(0xFF0F172A),
          fontWeight: FontWeight.w600,
        ),

        bodyLarge: TextStyle(color: Color(0xFF0F172A)),

        bodyMedium: TextStyle(color: Color(0xFF334155)),

        bodySmall: TextStyle(color: Color(0xFF64748B)),
      ),
    );
  }

  // =========================================================
  // DARK THEME
  // =========================================================
  static ThemeData darkTheme() {
    const primaryColor = Color(0xFF7C8CFF);

    final colorScheme = const ColorScheme.dark().copyWith(
      primary: primaryColor,
      secondary: Color(0xFFA5B4FC),
      tertiary: Color(0xFFC7D2FE),

      surface: Color(0xFF161B26),
      onSurface: Colors.white,

      primaryContainer: Color(0xFF1E293B),
      secondaryContainer: Color(0xFF232B3E),

      outline: Color(0xFF2F3547),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,

      // =========================================================
      // BACKGROUND
      // =========================================================
      scaffoldBackgroundColor: const Color(0xFF0B1120),

      // =========================================================
      // APP BAR
      // =========================================================
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,

        foregroundColor: Colors.white,

        elevation: 0,

        scrolledUnderElevation: 0,

        centerTitle: false,

        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),

        iconTheme: IconThemeData(color: Colors.white),
      ),

      // =========================================================
      // CARD
      // =========================================================
      cardTheme: CardThemeData(
        color: const Color(0xFF161B26),

        surfaceTintColor: Colors.transparent,

        elevation: 0,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        margin: EdgeInsets.zero,
      ),

      // =========================================================
      // DIALOG
      // =========================================================
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF161B26),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      // =========================================================
      // INPUT
      // =========================================================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,

        fillColor: const Color(0xFF1E2433),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),

        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),

        labelStyle: const TextStyle(color: Color(0xFFCBD5E1)),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),

          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),

          borderSide: const BorderSide(color: Color(0xFF2A3142)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),

          borderSide: const BorderSide(color: primaryColor, width: 1.6),
        ),
      ),

      // =========================================================
      // ELEVATED BUTTON
      // =========================================================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,

          foregroundColor: Colors.white,

          minimumSize: const Size(double.infinity, 54),

          elevation: 0,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),

          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      // =========================================================
      // OUTLINED BUTTON
      // =========================================================
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,

          side: const BorderSide(color: Color(0xFF31384D)),

          minimumSize: const Size(double.infinity, 54),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      // =========================================================
      // CHIP
      // =========================================================
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF232B3E),

        selectedColor: primaryColor,

        disabledColor: const Color(0xFF31384D),

        labelStyle: const TextStyle(
          color: Color(0xFFC7D2FE),
          fontWeight: FontWeight.w600,
        ),

        secondaryLabelStyle: const TextStyle(color: Colors.white),

        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      // =========================================================
      // BOTTOM NAVIGATION
      // =========================================================
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF111827),

        selectedItemColor: primaryColor,
        unselectedItemColor: Color(0xFF6B7280),

        elevation: 0,

        type: BottomNavigationBarType.fixed,
      ),

      // =========================================================
      // DIVIDER
      // =========================================================
      dividerColor: const Color(0xFF2A3142),

      // =========================================================
      // TEXT
      // =========================================================
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),

        titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),

        titleMedium: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),

        bodyLarge: TextStyle(color: Colors.white),

        bodyMedium: TextStyle(color: Color(0xFFE2E8F0)),

        bodySmall: TextStyle(color: Color(0xFF94A3B8)),
      ),
    );
  }
}