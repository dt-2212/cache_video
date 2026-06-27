import 'package:flutter/material.dart';

abstract class AppColors {
  // ── Backgrounds ──────────────────────────────────────────────
  // YouTube Dark Mode exact values
  static const Color background = Color(0xFF0F0F0F);     // YouTube's near-black
  static const Color surface = Color(0xFF212121);         // YouTube card/sidebar
  static const Color surfaceLight = Color(0xFF272727);    // YouTube elevated card

  // ── Brand / Accent ────────────────────────────────────────────
  // TikTok dual-tone accent — iconic, energetic, modern
  static const Color primary = Color(0xFFFE2C55);         // TikTok signature pink-red
  static const Color accent = Color(0xFF25F4EE);          // TikTok signature cyan
  static const Color primaryDark = Color(0xFFCC1A3D);     // Pressed / deep

  // ── Status ────────────────────────────────────────────────────
  static const Color destructive = Color(0xFFFF4444);
  static const Color success = Color(0xFF00B894);
  static const Color live = Color(0xFFFE2C55);            // Live badge matches primary

  // ── Text — YouTube exact values ───────────────────────────────
  static const Color textPrimary = Color(0xFFF1F1F1);     // YouTube's off-white
  static const Color textSecondary = Color(0xFFAAAAAA);   // YouTube secondary
  static const Color textMuted = Color(0xFF717171);       // YouTube dimmed
  static const Color textDisabled = Color(0xFF3F3F3F);

  // ── Misc ──────────────────────────────────────────────────────
  static const Color googleBlue = Color(0xFF4285F4);
  static const Color divider = Color(0xFF272727);         // YouTube's divider

  // ── Poster accent palette — dark, rich, cinematic ─────────────
  static const Color blue = Color(0xFF1A3A5C);
  static const Color lightBlue = Color(0xFF1A2C48);
  static const Color cyan = Color(0xFF0A3040);
  static const Color teal = Color(0xFF0A3030);
  static const Color mint = Color(0xFF0F3020);
  static const Color pink = Color(0xFF4A1030);
  static const Color coral = Color(0xFF4A1508);
  static const Color purple = Color(0xFF2A1050);
  static const Color skyBlue = Color(0xFF0F2238);
  static const Color slate = Color(0xFF1A2030);
  static const Color darkGradientStart = Color(0xFF212121);
  static const Color darkGradientEnd = Color(0xFF0F0F0F);

  // ── Gradients ─────────────────────────────────────────────────
  // TikTok's iconic dual-tone gradient
  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFFFF6B8A)],   // pink-red → soft pink
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Subtle dark surface gradient
  static const Gradient surfaceGradient = LinearGradient(
    colors: [surfaceLight, surface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
