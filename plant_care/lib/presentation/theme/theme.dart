import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 🎨 Colores base
  static const Color primaryGreen = Color(0xFF8AC73D); // verde principal
  static const Color secondaryGreen = Color(0xFFA5D6A7); // verde suave
  static const Color background = Color(0xFFF7F7ED); // fondo casi blanco
  static const Color textDark = Color(0xFF212121);
  static const Color textLight = Color(0xFF757575);

  // 🎯 Colores de estado
  static const Color healthyColor = primaryGreen;
  static const Color warningColor = Color(0xFFFFC107); // amarillo Material
  static const Color criticalColor = Color(0xFFE53935); // rojo intenso

  // 🔹 Helper para colores de estado
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "healthy":
        return healthyColor;
      case "warning":
        return warningColor;
      case "critical":
        return criticalColor;
      default:
        return textLight;
    }
  }

  // 🔹 Helper para iconos de estado
  static IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case "healthy":
        return Icons.check_circle;
      case "warning":
        return Icons.warning;
      case "critical":
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      primaryColor: primaryGreen,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
        secondary: secondaryGreen,
        surface: background,
        error: criticalColor,
        tertiary: warningColor, // ⚠️ warning mapeado como tertiary
      ),
      textTheme: GoogleFonts.ralewayTextTheme().copyWith(
        headlineLarge: GoogleFonts.raleway(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        bodyLarge: GoogleFonts.raleway(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textDark,
        ),
        bodyMedium: GoogleFonts.raleway(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textLight,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: textDark,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: secondaryGreen),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: GoogleFonts.raleway(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        color: Colors.white,
      ),
    );
  }
    static ThemeData get darkTheme {
  const Color darkBackground = Color(0xFF002933);
  const Color darkCard = Color(0xFF03383C);

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    primaryColor: primaryGreen,
    colorScheme: const ColorScheme.dark(
      primary: primaryGreen,
      secondary: secondaryGreen,
      surface: darkCard,
    ),
    textTheme: GoogleFonts.ralewayTextTheme().copyWith(
  headlineLarge: GoogleFonts.raleway(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.white, // títulos principales
  ),
  headlineSmall: GoogleFonts.raleway(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white, // subtítulos (ej: "Needs Attention")
  ),
  bodyLarge: GoogleFonts.raleway(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white, // texto principal (ej: nombres de plantas)
  ),
  bodyMedium: GoogleFonts.raleway(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xFFB0BEC5), // texto secundario (ej: “Last watered…”)
  ),
  bodySmall: GoogleFonts.raleway(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFF90A4AE), // texto de tiempo (“3 hrs ago”)
  ),
),

    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: darkCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkCard,
      selectedItemColor: primaryGreen,
      unselectedItemColor: Colors.white70,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
}

