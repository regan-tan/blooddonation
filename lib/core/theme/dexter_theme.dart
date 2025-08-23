import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 🦕 Dexter Design System
/// Inspired by the adorable green dino mascot donating blood
class DexterTokens extends ThemeExtension<DexterTokens> {
  // 🎨 Dexter Dino Palette (from actual mascot)
  static const Color dexGreen = Color(0xFF7EDC86);     // dino body - main green
  static const Color dexLeaf = Color(0xFF4A7C59);      // dino outline/shadow
  static const Color dexForest = Color(0xFF2D5233);    // dark outline/borders
  static const Color dexBlush = Color(0xFFFF9AA8);     // cute cheeks
  static const Color dexBlood = Color(0xFFE85A4F);     // blood bag color
  static const Color dexGold = Color(0xFF8C7A35);      // warm accent
  static const Color dexIvory = Color(0xFFFFFDF7);     // clean background
  static const Color dexInk = Color(0xFF1C1C1C);       // text
  
  // 🦕 Dino-specific colors
  static const Color dinoBodyLight = Color(0xFF9AE6B4); // lighter dino shade
  static const Color dinoBodyDark = Color(0xFF68D391);  // darker dino shade
  static const Color dinoBelly = Color(0xFFB8F5C7);     // belly area
  static const Color dinoOutline = Color(0xFF2F855A);   // strong outline

  // 🎯 Semantic Colors
  static const Color success = dexGreen;
  static const Color warning = dexGold;
  static const Color error = dexBlood;
  static const Color info = dexLeaf;

  // 🔵 Shape Tokens
  static const double radiusSmall = 12.0;
  static const double radiusMedium = 20.0;
  static const double radiusLarge = 28.0;
  static const double radiusExtraLarge = 32.0;

  // 🌟 Elevation
  static const double elevationLow = 1.0;
  static const double elevationMedium = 3.0;
  static const double elevationHigh = 6.0;

  const DexterTokens({
    this.primaryColor = dexGreen,
    this.secondaryColor = dexLeaf,
    this.accentColor = dexBlood,
    this.surfaceColor = dexIvory,
    this.textColor = dexInk,
  });

  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color surfaceColor;
  final Color textColor;

  @override
  DexterTokens copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? accentColor,
    Color? surfaceColor,
    Color? textColor,
  }) {
    return DexterTokens(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      accentColor: accentColor ?? this.accentColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      textColor: textColor ?? this.textColor,
    );
  }

  @override
  DexterTokens lerp(DexterTokens? other, double t) {
    if (other is! DexterTokens) return this;
    return DexterTokens(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t)!,
      accentColor: Color.lerp(accentColor, other.accentColor, t)!,
      surfaceColor: Color.lerp(surfaceColor, other.surfaceColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
    );
  }
}

/// 🎨 Dexter Theme Factory
class DexterTheme {
  static ThemeData get lightTheme {
    final textTheme = _buildTextTheme(DexterTokens.dexInk);
    final colorScheme = _buildLightColorScheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: DexterTokens.dexIvory,
      extensions: const [DexterTokens()],
      
      // 🎯 App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: DexterTokens.dexIvory,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: DexterTokens.dexForest,
        ),
        iconTheme: const IconThemeData(color: DexterTokens.dexForest),
      ),
      
      // 🎯 Cards
      cardTheme: CardThemeData(
        color: DexterTokens.dexIvory,
        elevation: DexterTokens.elevationMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DexterTokens.radiusMedium),
          side: const BorderSide(color: DexterTokens.dexLeaf, width: 1),
        ),
        shadowColor: DexterTokens.dexLeaf.withOpacity(0.1),
      ),
      
      // 🎯 Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DexterTokens.dexGreen,
          foregroundColor: Colors.white,
          elevation: DexterTokens.elevationMedium,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DexterTokens.radiusLarge),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: DexterTokens.dexGreen,
          side: const BorderSide(color: DexterTokens.dexGreen, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DexterTokens.radiusLarge),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // 🎯 Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DexterTokens.dexIvory,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DexterTokens.radiusMedium),
          borderSide: const BorderSide(color: DexterTokens.dexLeaf),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DexterTokens.radiusMedium),
          borderSide: const BorderSide(color: DexterTokens.dexLeaf, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        labelStyle: GoogleFonts.inter(color: DexterTokens.dexForest),
        hintStyle: GoogleFonts.inter(color: DexterTokens.dexForest.withOpacity(0.6)),
      ),
      
      // 🎯 Chips
      chipTheme: ChipThemeData(
        backgroundColor: DexterTokens.dexIvory,
        selectedColor: DexterTokens.dexGreen.withOpacity(0.2),
        side: const BorderSide(color: DexterTokens.dexLeaf),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DexterTokens.radiusMedium),
        ),
        labelStyle: GoogleFonts.inter(
          color: DexterTokens.dexForest,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      // 🎯 Snack Bars
      snackBarTheme: SnackBarThemeData(
        backgroundColor: DexterTokens.dexForest,
        contentTextStyle: GoogleFonts.inter(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DexterTokens.radiusMedium),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      
      // 🎯 Bottom Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: DexterTokens.dexIvory,
        selectedItemColor: DexterTokens.dexGreen,
        unselectedItemColor: DexterTokens.dexForest.withOpacity(0.6),
        selectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final lightTheme = DexterTheme.lightTheme;
    return lightTheme.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: DexterTokens.dexForest,
      extensions: [
        const DexterTokens().copyWith(
          surfaceColor: DexterTokens.dexForest,
          textColor: DexterTokens.dexIvory,
        ),
      ],
    );
  }

  static TextTheme _buildTextTheme(Color textColor) {
    return TextTheme(
      // Headlines - Nunito (rounded, friendly)
      displayLarge: GoogleFonts.nunito(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textColor,
        height: 1.25,
      ),
      displayMedium: GoogleFonts.nunito(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textColor,
        height: 1.25,
      ),
      displaySmall: GoogleFonts.nunito(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textColor,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textColor,
        height: 1.3,
      ),
      headlineSmall: GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.3,
      ),
      
      // Body - Inter (clean, readable)
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textColor,
        height: 1.35,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textColor,
        height: 1.35,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textColor,
        height: 1.35,
      ),
      
      // Labels
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
    );
  }

  static ColorScheme _buildLightColorScheme() {
    return ColorScheme.fromSeed(
      seedColor: DexterTokens.dexGreen,
      brightness: Brightness.light,
      primary: DexterTokens.dexGreen,
      secondary: DexterTokens.dexLeaf,
      tertiary: DexterTokens.dexBlood,
      surface: DexterTokens.dexIvory,
      background: DexterTokens.dexIvory,
      error: DexterTokens.dexBlood,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: DexterTokens.dexInk,
      onBackground: DexterTokens.dexInk,
      onError: Colors.white,
    );
  }
}

/// 🎯 Theme Extension Helper
extension DexterThemeExtension on BuildContext {
  DexterTokens get dexter => Theme.of(this).extension<DexterTokens>()!;
}
