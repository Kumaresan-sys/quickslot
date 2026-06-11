import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/theme.dart';

class DateSelectorBar extends StatelessWidget {
  final String selectedDate;
  final VoidCallback onSelectDate;

  const DateSelectorBar({
    super.key,
    required this.selectedDate,
    required this.onSelectDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                Icons.calendar_month_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected date',
                    style: TextStyle(
                      color: context.appColors.mutedText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    DateFormat(
                      'EEE, MMM d, yyyy',
                    ).format(DateTime.parse(selectedDate)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: onSelectDate,
              icon: const Icon(Icons.edit_calendar_rounded, size: 18),
              label: const Text('Change'),
            ),
          ],
        ),
      ),
    );
  }
}
