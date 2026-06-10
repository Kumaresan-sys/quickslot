// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************


Map<String, dynamic> _$SlotModelToJson(SlotModel instance) => <String, dynamic>{
  'id': instance.id,
  'venue_id': instance.mappedVenueId,
  'slot_time': instance.mappedSlotTime,
};


Map<String, dynamic> _$DailySlotModelToJson(DailySlotModel instance) =>
    <String, dynamic>{
      'date': instance.date,
      'status': instance.status,
      'slot_id': instance.mappedSlotId,
      'venue_id': instance.mappedVenueId,
      'slot_time': instance.mappedSlotTime,
    };
