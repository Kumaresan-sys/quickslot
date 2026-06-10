// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) => BookingModel(
  id: json['id'] as String,
  mappedUserId: json['user_id'] as String,
  mappedVenueId: json['venue_id'] as String,
  mappedSlotId: json['slot_id'] as String,
  mappedBookingDate: json['booking_date'] as String,
  status: json['status'] as String,
  mappedCreatedAt: json['created_at'] as String,
);

Map<String, dynamic> _$BookingModelToJson(BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'user_id': instance.mappedUserId,
      'venue_id': instance.mappedVenueId,
      'slot_id': instance.mappedSlotId,
      'booking_date': instance.mappedBookingDate,
      'created_at': instance.mappedCreatedAt,
    };
