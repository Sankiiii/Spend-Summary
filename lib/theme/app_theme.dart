import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppColors {
  static const bg          = Color(0xFF0A0A12);
  static const surface     = Color(0xFF13131E);
  static const surfaceHigh = Color(0xFF1C1C2A);
  static const border      = Color(0xFF252536);
  static const borderLight = Color(0xFF303048);

  static const accent     = Color(0xFF7C6FFF);
  static const accentSoft = Color(0xFF9F97FF);

  static const textPrimary   = Color(0xFFF2F2FF);
  static const textSecondary = Color(0xFF8888AA);
  static const textMuted     = Color(0xFF4E4E6A);

  static const success = Color(0xFF34D399);
  static const danger  = Color(0xFFFF6B6B);
  static const warning = Color(0xFFFFBE0B);

  static const headerGradStart = Color(0xFF1E1040);
  static const headerGradMid   = Color(0xFF0E0826);
  static const headerGradEnd   = Color(0xFF080C1E);
}

abstract class AppGradients {
  static const header = LinearGradient(
    begin: Alignment.topLeft,
    end:   Alignment.bottomRight,
    colors: [AppColors.headerGradStart, AppColors.headerGradMid, AppColors.headerGradEnd],
    stops:  [0.0, 0.55, 1.0],
  );

  static const accentBtn = LinearGradient(
    colors: [Color(0xFF7C6FFF), Color(0xFF9F97FF)],
  );

  static const bottomFade = LinearGradient(
    begin:  Alignment.topCenter,
    end:    Alignment.bottomCenter,
    colors: [Colors.transparent, AppColors.bg],
  );
}

ThemeData buildAppTheme() => ThemeData(
      useMaterial3:            true,
      brightness:              Brightness.dark,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        surface: AppColors.surface,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor:    AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      splashFactory:  NoSplash.splashFactory,
      highlightColor: Colors.transparent,
    );

abstract class AppText {
  static TextStyle get displayLg  => GoogleFonts.inter(fontSize: 40.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -1.5, height: 1.0);
  static TextStyle get displayMd  => GoogleFonts.inter(fontSize: 32.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -1.0);
  static TextStyle get displaySm  => GoogleFonts.inter(fontSize: 24.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: -0.5);

  static TextStyle get h1         => GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static TextStyle get h2         => GoogleFonts.inter(fontSize: 17.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static TextStyle get h3         => GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary);

  
  static TextStyle get bodyLg     => GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.w400, color: AppColors.textPrimary);
  static TextStyle get bodyMd     => GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.w400, color: AppColors.textSecondary);
  static TextStyle get bodySm     => GoogleFonts.inter(fontSize: 11.sp, fontWeight: FontWeight.w400, color: AppColors.textMuted);

  static TextStyle get labelLg    => GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static TextStyle get labelMd    => GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondary);
  static TextStyle get labelSm    => GoogleFonts.inter(fontSize: 10.sp, fontWeight: FontWeight.w600, color: AppColors.textMuted, letterSpacing: 0.8);

  static TextStyle get monoLg     => GoogleFonts.jetBrainsMono(fontSize: 15.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static TextStyle get monoMd     => GoogleFonts.jetBrainsMono(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static TextStyle get monoSm     => GoogleFonts.jetBrainsMono(fontSize: 11.sp, fontWeight: FontWeight.w500, color: AppColors.textMuted);
}
