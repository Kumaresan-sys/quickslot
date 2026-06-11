import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../domain/entities/slot.dart';
import 'app_button.dart';

class BookingBar extends StatelessWidget {
  final DailySlot? selectedSlot;
  final bool isLoading;
  final VoidCallback? onBook;

  const BookingBar({
    super.key,
    required this.selectedSlot,
    required this.isLoading,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(top: BorderSide(color: context.appColors.border)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected slot',
                      style: TextStyle(
                        color: context.appColors.mutedText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      selectedSlot?.slotTime ?? 'Choose a time',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                flex: 2,
                child: AppButton(
                  label: 'Confirm booking',
                  icon: Icons.event_available_rounded,
                  isLoading: isLoading,
                  onPressed: selectedSlot != null ? onBook : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
