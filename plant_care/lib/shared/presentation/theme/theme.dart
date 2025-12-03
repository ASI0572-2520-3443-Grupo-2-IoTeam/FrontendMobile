import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ============================================================================
  // ENHANCED COLOR PALETTE
  // ============================================================================

  // Primary Colors - Vibrant greens for plant theme
  static const Color primaryGreen = Color(0xFF8AC73D);
  static const Color primaryGreenLight = Color(0xFFA8D96E);
  static const Color primaryGreenDark = Color(0xFF6FA82D);

  // Secondary Colors - Complementary greens
  static const Color secondaryGreen = Color(0xFFA5D6A7);
  static const Color secondaryGreenLight = Color(0xFFC8E6C9);
  static const Color secondaryGreenDark = Color(0xFF81C784);

  // Accent Colors - For visual interest
  static const Color accentTeal = Color(0xFF26A69A);
  static const Color accentAmber = Color(0xFFFFB300);

  // Background Colors - Light Theme
  static const Color background = Color(0xFFF7F7ED);
  static const Color backgroundLight = Color(0xFFFFFFF5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F0);

  // Background Colors - Dark Theme
  static const Color darkBackground = Color(0xFF002933);
  static const Color darkBackgroundLight = Color(0xFF003D4A);
  static const Color darkSurface = Color(0xFF03383C);
  static const Color darkSurfaceVariant = Color(0xFF044D52);

  // Text Colors - Light Theme
  static const Color textDark = Color(0xFF212121);
  static const Color textMedium = Color(0xFF424242);
  static const Color textLight = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);

  // Text Colors - Dark Theme
  static const Color textDarkPrimary = Color(0xFFFFFFFF);
  static const Color textDarkSecondary = Color(0xFFB0BEC5);
  static const Color textDarkTertiary = Color(0xFF90A4AE);
  static const Color textDarkHint = Color(0xFF78909C);

  // Status Colors - Enhanced with gradients
  static const Color healthyColor = Color(0xFF66BB6A);
  static const Color healthyColorLight = Color(0xFF81C784);
  static const Color warningColor = Color(0xFFFFA726);
  static const Color warningColorLight = Color(0xFFFFB74D);
  static const Color criticalColor = Color(0xFFEF5350);
  static const Color criticalColorLight = Color(0xFFE57373);
  static const Color dangerColor = Color(0xFFD32F2F);

  // Semantic Colors
  static const Color successColor = Color(0xFF66BB6A);
  static const Color infoColor = Color(0xFF42A5F5);
  static const Color errorColor = Color(0xFFEF5350);

  // Overlay Colors
  static const Color overlayLight = Color(0x0A000000);
  static const Color overlayMedium = Color(0x1F000000);
  static const Color overlayDark = Color(0x3D000000);

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Get color based on plant status
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "healthy":
        return healthyColor;
      case "warning":
        return warningColor;
      case "critical":
        return criticalColor;
      case "danger":
        return dangerColor;
      default:
        return textLight;
    }
  }

  /// Get gradient colors for status
  static List<Color> getStatusGradient(String status) {
    switch (status.toLowerCase()) {
      case "healthy":
        return [healthyColor, healthyColorLight];
      case "warning":
        return [warningColor, warningColorLight];
      case "critical":
        return [criticalColor, criticalColorLight];
      default:
        return [textLight, textHint];
    }
  }

  /// Get icon for plant status
  static IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case "healthy":
        return Icons.check_circle;
      case "warning":
        return Icons.warning_amber;
      case "critical":
        return Icons.error;
      case "danger":
        return Icons.dangerous;
      default:
        return Icons.info_outline;
    }
  }

  // ============================================================================
  // LIGHT THEME
  // ============================================================================

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      primaryColor: primaryGreen,

      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: primaryGreen,
        onPrimary: Colors.white,
        primaryContainer: primaryGreenLight,
        onPrimaryContainer: primaryGreenDark,

        secondary: secondaryGreen,
        onSecondary: textDark,
        secondaryContainer: secondaryGreenLight,
        onSecondaryContainer: secondaryGreenDark,

        tertiary: accentTeal,
        onTertiary: Colors.white,
        tertiaryContainer: accentTeal.withOpacity(0.2),
        onTertiaryContainer: accentTeal,

        error: errorColor,
        onError: Colors.white,
        errorContainer: errorColor.withOpacity(0.1),
        onErrorContainer: criticalColor,

        background: background,
        onBackground: textDark,

        surface: surface,
        onSurface: textDark,
        surfaceVariant: surfaceVariant,
        onSurfaceVariant: textMedium,

        outline: textLight,
        outlineVariant: textHint,

        shadow: overlayMedium,
        scrim: overlayDark,

        inverseSurface: textDark,
        onInverseSurface: surface,
        inversePrimary: primaryGreenLight,
      ),

      // Typography - Complete scale
      textTheme: GoogleFonts.ralewayTextTheme().copyWith(
        // Display styles
        displayLarge: GoogleFonts.raleway(
          fontSize: 57,
          fontWeight: FontWeight.w700,
          color: textDark,
          letterSpacing: -0.25,
        ),
        displayMedium: GoogleFonts.raleway(
          fontSize: 45,
          fontWeight: FontWeight.w700,
          color: textDark,
        ),
        displaySmall: GoogleFonts.raleway(
          fontSize: 36,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),

        // Headline styles
        headlineLarge: GoogleFonts.raleway(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: textDark,
          letterSpacing: 0.25,
        ),
        headlineMedium: GoogleFonts.raleway(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        headlineSmall: GoogleFonts.raleway(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),

        // Title styles
        titleLarge: GoogleFonts.raleway(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textDark,
          letterSpacing: 0.15,
        ),
        titleMedium: GoogleFonts.raleway(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textDark,
          letterSpacing: 0.15,
        ),
        titleSmall: GoogleFonts.raleway(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textMedium,
          letterSpacing: 0.1,
        ),

        // Body styles
        bodyLarge: GoogleFonts.raleway(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textDark,
          letterSpacing: 0.5,
        ),
        bodyMedium: GoogleFonts.raleway(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textMedium,
          letterSpacing: 0.25,
        ),
        bodySmall: GoogleFonts.raleway(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textLight,
          letterSpacing: 0.4,
        ),

        // Label styles
        labelLarge: GoogleFonts.raleway(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textDark,
          letterSpacing: 0.1,
        ),
        labelMedium: GoogleFonts.raleway(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textMedium,
          letterSpacing: 0.5,
        ),
        labelSmall: GoogleFonts.raleway(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textLight,
          letterSpacing: 0.5,
        ),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.raleway(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        iconTheme: const IconThemeData(color: textDark),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),

        // Border styles
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textLight.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textLight.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),

        // Label and hint styles
        labelStyle: GoogleFonts.raleway(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textMedium,
        ),
        hintStyle: GoogleFonts.raleway(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textHint,
        ),

        // Icon theme
        prefixIconColor: textMedium,
        suffixIconColor: textMedium,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: primaryGreen.withOpacity(0.3),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),

          textStyle: GoogleFonts.raleway(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryGreen,
          side: const BorderSide(color: primaryGreen, width: 1.5),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),

          textStyle: GoogleFonts.raleway(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryGreen,

          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),

          textStyle: GoogleFonts.raleway(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: surface,
        elevation: 2,
        shadowColor: overlayMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(0),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: surfaceVariant,
        selectedColor: primaryGreenLight,
        disabledColor: textHint.withOpacity(0.1),
        labelStyle: GoogleFonts.raleway(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primaryGreen,
        unselectedItemColor: textLight,
        selectedLabelStyle: GoogleFonts.raleway(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.raleway(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: textLight.withOpacity(0.2),
        thickness: 1,
        space: 1,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: textMedium, size: 24),
    );
  }

  // ============================================================================
  // DARK THEME
  // ============================================================================

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      primaryColor: primaryGreen,

      // Color Scheme
      colorScheme: ColorScheme.dark(
        primary: primaryGreen,
        onPrimary: textDark,
        primaryContainer: primaryGreenDark,
        onPrimaryContainer: primaryGreenLight,

        secondary: secondaryGreen,
        onSecondary: textDark,
        secondaryContainer: secondaryGreenDark,
        onSecondaryContainer: secondaryGreenLight,

        tertiary: accentTeal,
        onTertiary: Colors.white,
        tertiaryContainer: accentTeal.withOpacity(0.2),
        onTertiaryContainer: accentTeal,

        error: errorColor,
        onError: Colors.white,
        errorContainer: errorColor.withOpacity(0.2),
        onErrorContainer: criticalColorLight,

        background: darkBackground,
        onBackground: textDarkPrimary,

        surface: darkSurface,
        onSurface: textDarkPrimary,
        surfaceVariant: darkSurfaceVariant,
        onSurfaceVariant: textDarkSecondary,

        outline: textDarkTertiary,
        outlineVariant: textDarkHint,

        shadow: Colors.black.withOpacity(0.3),
        scrim: Colors.black.withOpacity(0.5),

        inverseSurface: surface,
        onInverseSurface: textDark,
        inversePrimary: primaryGreenDark,
      ),

      // Typography - Complete scale for dark mode
      textTheme: GoogleFonts.ralewayTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            // Display styles
            displayLarge: GoogleFonts.raleway(
              fontSize: 57,
              fontWeight: FontWeight.w700,
              color: textDarkPrimary,
              letterSpacing: -0.25,
            ),
            displayMedium: GoogleFonts.raleway(
              fontSize: 45,
              fontWeight: FontWeight.w700,
              color: textDarkPrimary,
            ),
            displaySmall: GoogleFonts.raleway(
              fontSize: 36,
              fontWeight: FontWeight.w600,
              color: textDarkPrimary,
            ),

            // Headline styles
            headlineLarge: GoogleFonts.raleway(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: textDarkPrimary,
              letterSpacing: 0.25,
            ),
            headlineMedium: GoogleFonts.raleway(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: textDarkPrimary,
            ),
            headlineSmall: GoogleFonts.raleway(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: textDarkPrimary,
            ),

            // Title styles
            titleLarge: GoogleFonts.raleway(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: textDarkPrimary,
              letterSpacing: 0.15,
            ),
            titleMedium: GoogleFonts.raleway(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textDarkPrimary,
              letterSpacing: 0.15,
            ),
            titleSmall: GoogleFonts.raleway(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textDarkSecondary,
              letterSpacing: 0.1,
            ),

            // Body styles
            bodyLarge: GoogleFonts.raleway(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textDarkPrimary,
              letterSpacing: 0.5,
            ),
            bodyMedium: GoogleFonts.raleway(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: textDarkSecondary,
              letterSpacing: 0.25,
            ),
            bodySmall: GoogleFonts.raleway(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: textDarkTertiary,
              letterSpacing: 0.4,
            ),

            // Label styles
            labelLarge: GoogleFonts.raleway(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textDarkPrimary,
              letterSpacing: 0.1,
            ),
            labelMedium: GoogleFonts.raleway(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textDarkSecondary,
              letterSpacing: 0.5,
            ),
            labelSmall: GoogleFonts.raleway(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: textDarkTertiary,
              letterSpacing: 0.5,
            ),
          ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: textDarkPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.raleway(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textDarkPrimary,
        ),
        iconTheme: const IconThemeData(color: textDarkPrimary),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),

        // Border styles
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textDarkTertiary.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textDarkTertiary.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),

        // Label and hint styles
        labelStyle: GoogleFonts.raleway(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textDarkSecondary,
        ),
        hintStyle: GoogleFonts.raleway(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textDarkHint,
        ),

        // Icon theme
        prefixIconColor: textDarkSecondary,
        suffixIconColor: textDarkSecondary,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.3),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),

          textStyle: GoogleFonts.raleway(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryGreen,
          side: const BorderSide(color: primaryGreen, width: 1.5),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),

          textStyle: GoogleFonts.raleway(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryGreen,

          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),

          textStyle: GoogleFonts.raleway(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(0),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: darkSurfaceVariant,
        selectedColor: primaryGreenDark,
        disabledColor: textDarkHint.withOpacity(0.1),
        labelStyle: GoogleFonts.raleway(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textDarkPrimary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: primaryGreen,
        unselectedItemColor: textDarkTertiary,
        selectedLabelStyle: GoogleFonts.raleway(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.raleway(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: textDarkTertiary.withOpacity(0.2),
        thickness: 1,
        space: 1,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: textDarkSecondary, size: 24),
    );
  }
}
