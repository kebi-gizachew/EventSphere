import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../utils/constants.dart';

class DeleteEventDialog {
  static Future<bool> show(BuildContext context, String eventTitle) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.deleteTitle),
        content: Text('${AppStrings.deleteMessage}\n\n"$eventTitle"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}