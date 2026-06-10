import 'package:equatable/equatable.dart';

class Booking extends Equatable {
  final String id;
  final String userId;
  final String venueId;
  final String slotId;
  final String bookingDate;
  final String status;
  final DateTime createdAt;

  const Booking({
    required this.id,
    required this.userId,
    required this.venueId,
    required this.slotId,
    required this.bookingDate,
    required this.status,
    required this.createdAt,
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
      ];
}
