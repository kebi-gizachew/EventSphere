import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../utils/constants.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.category,
    this.compact = false,
    this.selected = false,
    this.onTap,
  });

  final EventCategory category;
  final bool compact;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.categoryColor(category);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 10,
          vertical: compact ? 4 : 6,
        ),
        decoration: BoxDecoration(
          color: selected ? color : color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          category.label,
          style: TextStyle(
            fontSize: compact ? 11 : 12,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : color,
          ),
        ),
      ),
    );
  }
}