import 'package:flutter/material.dart';

import '../utils/constants.dart';

class AppColors {
  AppColors._();

  // Brand palette
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryLight = Color(0xFFA29BFE);
  static const Color accent = Color(0xFFFF7675);
  static const Color accentTeal = Color(0xFF00CEC9);
  static const Color success = Color(0xFF00B894);
  static const Color warning = Color(0xFFFDCB6E);

  // Light theme
  static const Color lightBackground = Color(0xFFF4F6FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF1E1E2E);
  static const Color lightMuted = Color(0xFF6B7280);

  // Dark theme
  static const Color darkBackground = Color(0xFF0D0D14);
  static const Color darkSurface = Color(0xFF16162A);
  static const Color darkCard = Color(0xFF1E1E35);
  static const Color darkText = Color(0xFFF0F0F5);
  static const Color darkMuted = Color(0xFF9CA3AF);

  static Color categoryColor(EventCategory category) {
    switch (category) {
      case EventCategory.technology:
        return const Color(0xFF6C5CE7);
      case EventCategory.music:
        return const Color(0xFFE84393);
      case EventCategory.sports:
        return const Color(0xFF00B894);
      case EventCategory.education:
        return const Color(0xFF0984E3);
      case EventCategory.business:
        return const Color(0xFFFDAA00);
      case EventCategory.art:
        return const Color(0xFFFF7675);
    }
  }

  static Color categoryGradientStart(EventCategory category) {
    return categoryColor(category).withValues(alpha: 0.85);
  }

  static Color categoryGradientEnd(EventCategory category) {
    return categoryColor(category).withValues(alpha: 0.45);
  }
}