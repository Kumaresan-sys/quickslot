import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickslot/core/network/socket_client.dart';
import 'package:quickslot/domain/entities/booking.dart';
import 'package:quickslot/domain/entities/slot.dart';
import 'package:quickslot/domain/services/booking_failure_classifier.dart';
import 'package:quickslot/domain/usecases/booking_usecases.dart';
import 'package:quickslot/domain/usecases/get_slots_usecase.dart';
import 'package:quickslot/presentation/blocs/venue/venue_detail_bloc.dart';
import 'package:quickslot/presentation/blocs/venue/venue_detail_event.dart';
import 'package:quickslot/presentation/blocs/venue/venue_detail_state.dart';

class FakeSlotUpdateSource implements SlotUpdateSource {
  final _controller = StreamController<Map<String, dynamic>>.broadcast();
  final heldSlots = <String>[];
  final releasedSlots = <String>[];

  @override
  Stream<Map<String, dynamic>> get slotUpdates => _controller.stream;

  void emit(Map<String, dynamic> data) => _controller.add(data);

  @override
  void holdSlot({
    required String venueId,
    required String slotId,
    required String date,
    required String userId,
  }) {
    heldSlots.add(slotId);
  }

  @override
  void releaseSlot({
    required String venueId,
    required String slotId,
    required String date,
    required String userId,
  }) {
    releasedSlots.add(slotId);
  }

  Future<void> close() => _controller.close();
}

class FakeGetSlots implements GetSlots {
  @override
  Future<List<DailySlot>> call(
    String venueId,
    String date, {
    String? startTime,
    String? endTime,
  }) async {
    return const [
      DailySlot(
        slotId: 'slot1',
        venueId: 'venue1',
        date: '2026-06-15',
        slotTime: '06:00:00',
        status: 'AVAILABLE',
      ),
      DailySlot(
        slotId: 'slot2',
        venueId: 'venue1',
        date: '2026-06-15',
        slotTime: '07:00:00',
        status: 'AVAILABLE',
      ),
    ];
  }
}

class FakeBookSlot implements BookSlot {
  @override
  Future<Booking> call(String venueId, String slotId, String date) async {
    return Booking(
      id: 'booking1',
      bookingDate: date,
      status: 'CONFIRMED',
      createdAt: DateTime(2026, 6, 15),
    );
  }
}

class FakeBookingFailureClassifier implements BookingFailureClassifier {
  @override
  bool isConflict(Object error) => false;
}

void main() {
  late FakeSlotUpdateSource slotUpdateSource;

  VenueDetailBloc buildBloc() {
    slotUpdateSource = FakeSlotUpdateSource();
    return VenueDetailBloc(
      getSlotsUseCase: FakeGetSlots(),
      bookSlotUseCase: FakeBookSlot(),
      slotUpdateSource: slotUpdateSource,
      bookingFailureClassifier: FakeBookingFailureClassifier(),
    );
  }

  tearDown(() async {
    await slotUpdateSource.close();
  });

  blocTest<VenueDetailBloc, VenueDetailState>(
    'updates matching slot to held from socket update',
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const LoadSlotsEvent(venueId: 'venue1', date: '2026-06-15'));
      await Future<void>.delayed(Duration.zero);
      slotUpdateSource.emit({
        'venueId': 'venue1',
        'slotId': 'slot1',
        'date': '2026-06-15',
        'status': 'HELD',
        'userId': 'user2',
      });
      await Future<void>.delayed(Duration.zero);
    },
    expect: () => [
      isA<VenueDetailLoading>(),
      isA<VenueDetailLoaded>().having(
        (state) => state.slots.first.status,
        'first slot status',
        'AVAILABLE',
      ),
      isA<VenueDetailLoaded>()
          .having(
            (state) => state.slots.first.status,
            'first slot status',
            'HELD',
          )
          .having(
            (state) => state.slots.first.heldByUserId,
            'held by user id',
            'user2',
          )
          .having(
            (state) => state.slots.last.status,
            'second slot unchanged',
            'AVAILABLE',
          ),
    ],
  );
}
