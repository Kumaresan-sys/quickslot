import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/booking.dart';

part 'booking_model.g.dart';

@JsonSerializable()
class BookingModel extends Booking {
  @JsonKey(name: 'user_id')
  final String? mappedUserId;

  @JsonKey(name: 'venue_id')
  final String? mappedVenueId;

  @JsonKey(name: 'slot_id')
  final String? mappedSlotId;

  @JsonKey(name: 'booking_date')
  final String mappedBookingDate;

  @JsonKey(name: 'created_at')
  final String mappedCreatedAt;

  @JsonKey(name: 'venue_name')
  final String? mappedVenueName;

  @JsonKey(name: 'location')
  final String? mappedLocation;

  @JsonKey(name: 'slot_time')
  final String? mappedSlotTime;

  BookingModel({
    required super.id,
    this.mappedUserId,
    this.mappedVenueId,
    this.mappedSlotId,
    required this.mappedBookingDate,
    required super.status,
    required this.mappedCreatedAt,
    this.mappedVenueName,
    this.mappedLocation,
    this.mappedSlotTime,
  }) : super(
          userId: mappedUserId,
          venueId: mappedVenueId,
          slotId: mappedSlotId,
          bookingDate: mappedBookingDate,
          createdAt: DateTime.parse(mappedCreatedAt),
          venueName: mappedVenueName,
          location: mappedLocation,
          slotTime: mappedSlotTime,
        );

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        id: json['id'] as String,
        mappedUserId: json['user_id'] as String?,
        mappedVenueId: json['venue_id'] as String?,
        mappedSlotId: json['slot_id'] as String?,
        mappedBookingDate: json['booking_date'] as String,
        status: json['status'] as String,
        mappedCreatedAt: json['created_at'] as String,
        mappedVenueName: json['venue_name'] as String?,
        mappedLocation: json['location'] as String?,
        mappedSlotTime: json['slot_time'] as String?,
      );

  Map<String, dynamic> toJson() => _$BookingModelToJson(this);
}
