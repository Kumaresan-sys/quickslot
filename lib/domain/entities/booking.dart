import 'package:equatable/equatable.dart';

class Booking extends Equatable {
  final String id;
  final String? userId;
  final String? venueId;
  final String? slotId;
  final String bookingDate;
  final String status;
  final DateTime createdAt;
  final String? venueName;
  final String? location;
  final String? slotTime;

  const Booking({
    required this.id,
    this.userId,
    this.venueId,
    this.slotId,
    required this.bookingDate,
    required this.status,
    required this.createdAt,
    this.venueName,
    this.location,
    this.slotTime,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        venueId,
        slotId,
        bookingDate,
        status,
        createdAt,
        venueName,
        location,
        slotTime,
      ];
}
