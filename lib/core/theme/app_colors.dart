import 'package:flutter/material.dart';

/// Application color palette
class AppColors {
  AppColors._();

  // Primary Colors (Teal/Blue - Google brand inspired)
  static const Color primaryColor = Color(0xFF00897B);
  static const Color primaryLight = Color(0xFF4DB6AC);
  static const Color primaryDark = Color(0xFF00695C);

  // Secondary Colors (Orange/Amber accents)
  static const Color secondaryColor = Color(0xFFFF9800);
  static const Color secondaryLight = Color(0xFFFFB74D);
  static const Color secondaryDark = Color(0xFFF57C00);

  // Neutral Colors
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F2F5);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color divider = Color(0xFFE5E7EB);
  static const Color border = Color(0xFFD1D5DB);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // Role-specific Colors
  static const Color studentColor = Color(0xFF6366F1);
  static const Color teacherColor = Color(0xFF8B5CF6);
  static const Color hodColor = Color(0xFFEC4899);
  static const Color adminColor = Color(0xFF14B8A6);

  // Category Colors (for announcements/events)
  static const Color examColor = Color(0xFFEF4444);
  static const Color eventColor = Color(0xFF8B5CF6);
  static const Color maintenanceColor = Color(0xFFF59E0B);
  static const Color deadlineColor = Color(0xFFEC4899);
  static const Color generalColor = Color(0xFF6B7280);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, Color(0xFF26A69A)],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00897B), Color(0xFF00ACC1)],
  );

  // Shadows
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get elevatedShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];
}
