import 'package:flutter/material.dart';

import '../../domain/entities/slot.dart';
import 'gradient_button.dart';

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
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              offset: const Offset(0, -4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Selected', style: TextStyle(color: Colors.grey)),
                  Text(
                    selectedSlot?.slotTime ?? 'None',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: GradientButton(
                text: 'CONFIRM BOOKING',
                isLoading: isLoading,
                onPressed: selectedSlot != null ? onBook : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
