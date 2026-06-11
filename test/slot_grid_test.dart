import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickslot/core/theme.dart';
import 'package:quickslot/domain/entities/slot.dart';
import 'package:quickslot/presentation/widgets/slot_grid.dart';

void main() {
  testWidgets('held slot renders yellow and is not selectable', (tester) async {
    var selectedCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: SlotGrid(
            slots: const [
              DailySlot(
                slotId: 'slot1',
                venueId: 'venue1',
                date: '2026-06-15',
                slotTime: '06:00:00',
                status: 'HELD',
                heldByUserId: 'user2',
              ),
            ],
            onSlotSelected: (_) => selectedCount++,
          ),
        ),
      ),
    );

    final slotText = tester.widget<Text>(find.text('06:00'));
    expect(slotText.style?.color, AppColors.warning);

    await tester.tap(find.text('06:00'));
    await tester.pump();

    expect(selectedCount, 0);
  });

  testWidgets('available slot is selectable', (tester) async {
    DailySlot? selectedSlot;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: SlotGrid(
            slots: const [
              DailySlot(
                slotId: 'slot1',
                venueId: 'venue1',
                date: '2026-06-15',
                slotTime: '06:00:00',
                status: 'AVAILABLE',
              ),
            ],
            onSlotSelected: (slot) => selectedSlot = slot,
          ),
        ),
      ),
    );

    await tester.tap(find.text('06:00'));
    await tester.pump();

    expect(selectedSlot?.slotId, 'slot1');
  });
}
