import 'package:equatable/equatable.dart';

abstract class VenueDetailEvent extends Equatable {
  const VenueDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadSlotsEvent extends VenueDetailEvent {
  final String venueId;
  final String date;

  const LoadSlotsEvent({required this.venueId, required this.date});

  @override
  List<Object?> get props => [venueId, date];
}

class SlotStatusUpdatedEvent extends VenueDetailEvent {
  final String slotId;
  final String status; // 'AVAILABLE' or 'BOOKED'

  const SlotStatusUpdatedEvent({required this.slotId, required this.status});

  @override
  List<Object?> get props => [slotId, status];
}

class BookSlotEvent extends VenueDetailEvent {
  final String venueId;
  final String slotId;
  final String date;

  const BookSlotEvent({
    required this.venueId,
    required this.slotId,
    required this.date,
  });

  @override
  List<Object?> get props => [venueId, slotId, date];
}
