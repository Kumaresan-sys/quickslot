import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/slot.dart';
import '../../../domain/usecases/get_slots_usecase.dart';
import '../../../domain/usecases/booking_usecases.dart';
import '../../../domain/services/booking_failure_classifier.dart';
import '../../../core/network/socket_client.dart';
import '../../utils/error_message_mapper.dart';
import 'venue_detail_event.dart';
import 'venue_detail_state.dart';

class VenueDetailBloc extends Bloc<VenueDetailEvent, VenueDetailState> {
  final GetSlots getSlotsUseCase;
  final BookSlot bookSlotUseCase;
  final SlotUpdateSource slotUpdateSource;
  final BookingFailureClassifier bookingFailureClassifier;

  late StreamSubscription _socketSubscription;

  VenueDetailBloc({
    required this.getSlotsUseCase,
    required this.bookSlotUseCase,
    required this.slotUpdateSource,
    required this.bookingFailureClassifier,
  }) : super(
         VenueDetailInitial(
           date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
         ),
       ) {
    on<LoadSlotsEvent>(_onLoadSlots);
    on<SlotStatusUpdatedEvent>(_onSlotStatusUpdated);
    on<HoldSlotEvent>(_onHoldSlot);
    on<ReleaseSlotEvent>(_onReleaseSlot);
    on<BookSlotEvent>(_onBookSlot);

    // Listen to WebSocket for real-time slot status changes
    _socketSubscription = slotUpdateSource.slotUpdates.listen((data) {
      if (data.containsKey('venueId') &&
          data.containsKey('slotId') &&
          data.containsKey('date') &&
          data.containsKey('status')) {
        add(
          SlotStatusUpdatedEvent(
            venueId: data['venueId'] as String,
            slotId: data['slotId'] as String,
            date: data['date'] as String,
            status: data['status'] as String,
            userId: data['userId'] as String?,
          ),
        );
      }
    });
  }

  Future<void> _onLoadSlots(
    LoadSlotsEvent event,
    Emitter<VenueDetailState> emit,
  ) async {
    emit(VenueDetailLoading(selectedDate: event.date, slots: state.slots));
    try {
      final slots = await getSlotsUseCase(event.venueId, event.date);
      if (slots.isEmpty) {
        emit(VenueDetailEmpty(selectedDate: event.date));
      } else {
        emit(VenueDetailLoaded(selectedDate: event.date, slots: slots));
      }
    } catch (e) {
      emit(
        VenueDetailError(
          selectedDate: event.date,
          slots: state.slots,
          message: ErrorMessageMapper.map(e),
        ),
      );
    }
  }

  void _onSlotStatusUpdated(
    SlotStatusUpdatedEvent event,
    Emitter<VenueDetailState> emit,
  ) {
    if (state.slots.isEmpty) return;
    if (event.date != state.selectedDate) return;

    final updatedSlots = state.slots.map((slot) {
      if (slot.slotId == event.slotId && slot.venueId == event.venueId) {
        return DailySlot(
          slotId: slot.slotId,
          venueId: slot.venueId,
          date: slot.date,
          slotTime: slot.slotTime,
          status: event.status,
          heldByUserId: event.status == 'HELD' ? event.userId : null,
        );
      }
      return slot;
    }).toList();

    // Re-emit Loaded state with updated slots so the grid rebuilds
    emit(
      VenueDetailLoaded(selectedDate: state.selectedDate, slots: updatedSlots),
    );
  }

  void _onHoldSlot(HoldSlotEvent event, Emitter<VenueDetailState> emit) {
    slotUpdateSource.holdSlot(
      venueId: event.venueId,
      slotId: event.slotId,
      date: event.date,
      userId: event.userId,
    );
  }

  void _onReleaseSlot(ReleaseSlotEvent event, Emitter<VenueDetailState> emit) {
    slotUpdateSource.releaseSlot(
      venueId: event.venueId,
      slotId: event.slotId,
      date: event.date,
      userId: event.userId,
    );
  }

  Future<void> _onBookSlot(
    BookSlotEvent event,
    Emitter<VenueDetailState> emit,
  ) async {
    emit(
      BookingInProgress(selectedDate: state.selectedDate, slots: state.slots),
    );
    try {
      final booking = await bookSlotUseCase(
        event.venueId,
        event.slotId,
        event.date,
      );
      emit(
        BookingSuccess(
          selectedDate: state.selectedDate,
          slots: state.slots,
          bookingId: booking.id,
        ),
      );
    } catch (e) {
      if (bookingFailureClassifier.isConflict(e)) {
        emit(
          BookingConflict(
            selectedDate: state.selectedDate,
            slots: state.slots,
            message: 'Sorry, this slot was just booked by someone else.',
          ),
        );
        // Auto-refresh the slots
        add(LoadSlotsEvent(venueId: event.venueId, date: state.selectedDate));
      } else {
        emit(
          VenueDetailError(
            selectedDate: state.selectedDate,
            slots: state.slots,
            message: ErrorMessageMapper.map(e),
          ),
        );
      }
    }
  }

  @override
  Future<void> close() {
    _socketSubscription.cancel();
    return super.close();
  }
}
