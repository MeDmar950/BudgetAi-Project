import 'package:flutter/material.dart';

abstract final class AppColors {
  // Backgrounds & Surfaces (Pitch & Slate Dark Palette)
  static const Color background = Color(0xFF0B0F17);
  static const Color surface = Color(0xFF151B26);
  static const Color surfaceElevated = Color(0xFF1E2638);
  static const Color surfaceCard = Color(0xFF242E42);
  static const Color border = Color(0xFF2D3748);
  static const Color borderSubtle = Color(0xFF1F2937);

  // Brand Accents (Emerald / Egypt Fintech Theme)
  static const Color primary = Color(0xFF10B981); // Emerald 500
  static const Color primaryLight = Color(0xFF34D399); // Emerald 400
  static const Color primaryDark = Color(0xFF059669); // Emerald 600
  static const Color primaryContainer = Color(0xFF064E3B);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Financial Semantics
  static const Color income = Color(0xFF22C55E); // Green 500
  static const Color incomeContainer = Color(0xFF14532D);
  static const Color expense = Color(0xFFEF4444); // Red 500
  static const Color expenseContainer = Color(0xFF7F1D1D);
  static const Color transfer = Color(0xFF3B82F6); // Blue 500
  static const Color transferContainer = Color(0xFF1E3A8A);

  // Feedback & Warnings
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningContainer = Color(0xFF78350F);
  static const Color error = Color(0xFFDC2626);
  static const Color success = Color(0xFF10B981);

  // Neutral Typography
  static const Color textPrimary = Color(0xFFF9FAFB);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color textInverse = Color(0xFF0B0F17);
}
