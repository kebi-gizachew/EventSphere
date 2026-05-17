import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class SnackbarHelper {
  SnackbarHelper._();

  static void showSuccess(BuildContext context, String message) {
    _show(context, message, AppColors.success, Icons.check_circle_rounded);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message, AppColors.accent, Icons.error_outline_rounded);
  }

  static void showInfo(BuildContext context, String message) {
    _show(context, message, AppColors.primary, Icons.info_outline_rounded);
  }

  static void _show(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: color,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
        ),
      );
  }
}