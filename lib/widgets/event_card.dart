import 'package:flutter/material.dart';

import '../models/event_model.dart';
import '../themes/app_colors.dart';
import 'category_chip.dart';
import 'status_badge.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.onEdit,
    required this.onDelete,
    required this.onFavoriteToggle,
  });

  final EventModel event;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.grey.shade200,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    event.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onFavoriteToggle,
                  icon: Icon(
                    event.isFavorite
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    size: 22,
                    color: event.isFavorite
                        ? AppColors.primary
                        : AppColors.lightMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                CategoryChip(category: event.category, compact: true),
                const SizedBox(width: 8),
                StatusBadge(isUpcoming: event.isUpcoming, compact: true),
              ],
            ),
            const SizedBox(height: 10),
            _MetaLine(Icons.calendar_today_outlined, event.formattedDate),
            const SizedBox(height: 4),
            _MetaLine(Icons.location_on_outlined, event.location),
            const SizedBox(height: 4),
            _MetaLine(
              Icons.person_outline,
              'Organizer #${event.organizerId}',
            ),
            const SizedBox(height: 4),
            _MetaLine(Icons.schedule, event.countdownLabel),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Edit'),
                ),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Delete'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.accent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkMuted
        : AppColors.lightMuted;
  return Row(
      children: [
        Icon(icon, size: 15, color: muted),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: muted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}