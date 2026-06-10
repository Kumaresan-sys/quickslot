import 'package:flutter/material.dart';
import '../../../domain/entities/slot.dart';

class SlotGrid extends StatelessWidget {
  final List<DailySlot> slots;
  final String? selectedSlotId;
  final Function(DailySlot) onSlotSelected;

  const SlotGrid({
    super.key,
    required this.slots,
    this.selectedSlotId,
    required this.onSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return const Center(child: Text('No slots available for this date.'));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        final isAvailable = slot.status == 'AVAILABLE';
        final isSelected = slot.slotId == selectedSlotId;

        Color bgColor;
        Color textColor;
        Color borderColor;

        if (!isAvailable) {
          bgColor = Colors.red.withValues(alpha: 0.1);
          textColor = Colors.red;
          borderColor = Colors.red.withValues(alpha: 0.3);
        } else if (isSelected) {
          bgColor = Theme.of(context).primaryColor;
          textColor = Colors.white;
          borderColor = Theme.of(context).primaryColor;
        } else {
          bgColor = Colors.green.withValues(alpha: 0.1);
          textColor = Colors.green;
          borderColor = Colors.green.withValues(alpha: 0.3);
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: isAvailable ? () => onSlotSelected(slot) : null,
              child: Container(
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor),
                ),
                alignment: Alignment.center,
                child: Text(
                  _formatTime(slot.slotTime),
                  style: TextStyle(
                    color: textColor,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatTime(String timeStr) {
    // timeStr is usually "HH:mm:ss", let's simplify to "HH:mm"
    final parts = timeStr.split(':');
    if (parts.length >= 2) {
      return '${parts[0]}:${parts[1]}';
    }
    return timeStr;
  }
}
