// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlotModel _$SlotModelFromJson(Map<String, dynamic> json) => SlotModel(
  id: json['id'] as String,
  mappedVenueId: json['venue_id'] as String,
  mappedSlotTime: json['slot_time'] as String,
);

Map<String, dynamic> _$SlotModelToJson(SlotModel instance) => <String, dynamic>{
  'id': instance.id,
  'venue_id': instance.mappedVenueId,
  'slot_time': instance.mappedSlotTime,
};

DailySlotModel _$DailySlotModelFromJson(Map<String, dynamic> json) =>
    DailySlotModel(
      mappedSlotId: json['slot_id'] as String,
      mappedVenueId: json['venue_id'] as String,
      date: json['date'] as String,
      mappedSlotTime: json['slot_time'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$DailySlotModelToJson(DailySlotModel instance) =>
    <String, dynamic>{
      'date': instance.date,
      'status': instance.status,
      'slot_id': instance.mappedSlotId,
      'venue_id': instance.mappedVenueId,
      'slot_time': instance.mappedSlotTime,
    };
