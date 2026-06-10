import 'package:equatable/equatable.dart';

class Slot extends Equatable {
  final String id;
  final String venueId;
  final String slotTime; // Format: HH:mm:ss

  const Slot({
    required this.id,
    required this.venueId,
    required this.slotTime,
  });

  @override
  List<Object?> get props => [id, venueId, slotTime];
}

class DailySlot extends Equatable {
  final String slotId;
  final String venueId;
  final String date;
  final String slotTime;
  final String status; // 'AVAILABLE' or 'BOOKED'

  const DailySlot({
    required this.slotId,
    required this.venueId,
    required this.date,
    required this.slotTime,
    required this.status,
  });

  @override
  List<Object?> get props => [slotId, venueId, date, slotTime, status];
}
