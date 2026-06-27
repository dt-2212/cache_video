import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color background = Color(0xFF0D0D0F);
  static const Color surface = Color(0xFF16161A);
  static const Color surfaceLight = Color(0xFF222228);

  static const Color primary = Color(0xFF8E2DE2); // Electric Purple
  static const Color accent = Color(0xFFFF512F); // Sunset Coral
  static const Color destructive = Color(0xFFFF5252);
  static const Color success = Color(0xFF2ED573);

  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textMuted = Colors.white38;
  static const Color textDisabled = Colors.white24;

  static const Color googleBlue = Color(0xFF4285F4);

  static const Color blue = Color(0xFF4A90E2);
  static const Color lightBlue = Color(0xFF3498DB);
  static const Color cyan = Color(0xFF00B4DB);
  static const Color teal = Color(0xFF50E3C2);
  static const Color mint = Color(0xFF11998E);
  static const Color pink = Color(0xFFFC466B);
  static const Color coral = Color(0xFFFF512F);
  static const Color purple = Color(0xFF9B59B6);
  static const Color skyBlue = Color(0xFF2193B0);

  static const Color slate = Color(0xFF2C3E50);
  static const Color darkGradientStart = Color(0xFF2C2C34);
  static const Color darkGradientEnd = Color(0xFF1A1A20);

  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
