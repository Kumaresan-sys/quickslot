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
  final String venueId;
  final String slotId;
  final String date;
  final String status; // 'AVAILABLE', 'HELD', or 'BOOKED'
  final String? userId;

  const SlotStatusUpdatedEvent({
    required this.venueId,
    required this.slotId,
    required this.date,
    required this.status,
    this.userId,
  });

  @override
  List<Object?> get props => [venueId, slotId, date, status, userId];
}

class HoldSlotEvent extends VenueDetailEvent {
  final String venueId;
  final String slotId;
  final String date;
  final String userId;

  const HoldSlotEvent({
    required this.venueId,
    required this.slotId,
    required this.date,
    required this.userId,
  });

  @override
  List<Object?> get props => [venueId, slotId, date, userId];
}

class ReleaseSlotEvent extends VenueDetailEvent {
  final String venueId;
  final String slotId;
  final String date;
  final String userId;

  const ReleaseSlotEvent({
    required this.venueId,
    required this.slotId,
    required this.date,
    required this.userId,
  });

  @override
  List<Object?> get props => [venueId, slotId, date, userId];
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
