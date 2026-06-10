import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/booking.dart';

part 'booking_model.g.dart';

@JsonSerializable()
class BookingModel extends Booking {
  @JsonKey(name: 'user_id')
  final String mappedUserId;

  @JsonKey(name: 'venue_id')
  final String mappedVenueId;

  @JsonKey(name: 'slot_id')
  final String mappedSlotId;

  @JsonKey(name: 'booking_date')
  final String mappedBookingDate;

  @JsonKey(name: 'created_at')
  final String mappedCreatedAt;

  BookingModel({
    required super.id,
    required this.mappedUserId,
    required this.mappedVenueId,
    required this.mappedSlotId,
    required this.mappedBookingDate,
    required super.status,
    required this.mappedCreatedAt,
  }) : super(
          userId: mappedUserId,
          venueId: mappedVenueId,
          slotId: mappedSlotId,
          bookingDate: mappedBookingDate,
          createdAt: DateTime.parse(mappedCreatedAt),
        );

  factory BookingModel.fromJson(Map<String, dynamic> json) => _$BookingModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookingModelToJson(this);
}
