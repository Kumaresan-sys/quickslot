import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../../domain/entities/slot.dart';

class SlotGrid extends StatelessWidget {
  final List<DailySlot> slots;
  final String? selectedSlotId;
  final ValueChanged<DailySlot> onSlotSelected;

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
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        mainAxisExtent: 52,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        final isAvailable = slot.status == 'AVAILABLE';
        final isSelected = slot.slotId == selectedSlotId;
        final style = _SlotStyle.resolve(context, isAvailable, isSelected);

        return Material(
          color: style.backgroundColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.md),
            onTap: isAvailable ? () => onSlotSelected(slot) : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: style.borderColor, width: 1.2),
              ),
              child: Text(
                _formatTime(slot.slotTime),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: style.textColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatTime(String timeStr) {
    final parts = timeStr.split(':');
    if (parts.length >= 2) return '${parts[0]}:${parts[1]}';
    return timeStr;
  }
}

class SlotLegend extends StatelessWidget {
  const SlotLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      children: const [
        _LegendItem(label: 'Available', color: AppColors.success),
        _LegendItem(label: 'Selected', color: AppColors.primary),
        _LegendItem(label: 'Booked', color: AppColors.danger),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;

  const _LegendItem({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: TextStyle(
            color: context.appColors.mutedText,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _SlotStyle {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const _SlotStyle({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });

  static _SlotStyle resolve(
    BuildContext context,
    bool isAvailable,
    bool isSelected,
  ) {
    if (!isAvailable) {
      return _SlotStyle(
        backgroundColor: context.appColors.danger.withValues(alpha: 0.08),
        borderColor: context.appColors.danger.withValues(alpha: 0.35),
        textColor: context.appColors.danger,
      );
    }
    if (isSelected) {
      return _SlotStyle(
        backgroundColor: Theme.of(context).colorScheme.primary,
        borderColor: Theme.of(context).colorScheme.primary,
        textColor: Colors.white,
      );
    }
    return _SlotStyle(
      backgroundColor: context.appColors.success.withValues(alpha: 0.08),
      borderColor: context.appColors.success.withValues(alpha: 0.35),
      textColor: context.appColors.success,
    );
  }
}
