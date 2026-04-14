import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1E3A8A);
  static const Color accent = Color(0xFF60A5FA);

  // Background Colors
  static const Color background = Color(0xFF0F172A);
  static const Color surface = Color(0xFF111827);
  static const Color card = Color(0xFF1E293B);
  
  // Input Colors
  static const Color inputBackground = Color(0xFF1F2937);
  static const Color inputBorder = Color(0xFF374151);
  static const Color inputFocusedBorder = Color(0xFF3B82F6);

  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textHint = Color(0xFF64748B);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // Gradients
  static const Gradient splashGradient = RadialGradient(
    colors: [
      Color(0xFF1E3A8A),
      Color(0xFF0F172A),
    ],
    radius: 1.2,
    center: Alignment.center,
  );
}
