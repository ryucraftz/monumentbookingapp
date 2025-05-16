import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF4A3FE4);
  static const Color primaryLight = Color(0xFF6B5FE8);
  static const Color primaryDark = Color(0xFF3A2FD4);

  // Secondary Colors
  static const Color secondary = Color(0xFF2FD4B6);
  static const Color secondaryLight = Color(0xFF4FE4C6);
  static const Color secondaryDark = Color(0xFF1FC4A6);

  // Background Colors
  static const Color background = Color(0xFFF8F9FF);
  static const Color surface = Colors.white;
  static const Color surfaceLight = Color(0xFFF0F2FF);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF29B6F6);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF4A3FE4),
    Color(0xFF6B5FE8),
  ];

  static const List<Color> backgroundGradient = [
    Color(0xFFF8F9FF),
    Color(0xFFF0F2FF),
    Colors.white,
  ];

  // Overlay Colors
  static Color overlay = Colors.black.withOpacity(0.5);
  static Color primaryOverlay = primary.withOpacity(0.1);
  static Color secondaryOverlay = secondary.withOpacity(0.1);

  // Border Colors
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderMedium = Color(0xFFBDBDBD);
  static const Color borderDark = Color(0xFF9E9E9E);

  // Shadow Colors
  static Color shadowLight = Colors.black.withOpacity(0.05);
  static Color shadowMedium = Colors.black.withOpacity(0.1);
  static Color shadowDark = Colors.black.withOpacity(0.2);
}
