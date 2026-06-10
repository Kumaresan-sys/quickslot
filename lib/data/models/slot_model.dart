import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/slot.dart';

part 'slot_model.g.dart';

@JsonSerializable()
class SlotModel extends Slot {
  @JsonKey(name: 'venue_id')
  final String mappedVenueId;

  @JsonKey(name: 'slot_time')
  final String mappedSlotTime;

  const SlotModel({
    required super.id,
    required this.mappedVenueId,
    required this.mappedSlotTime,
  }) : super(venueId: mappedVenueId, slotTime: mappedSlotTime);

  factory SlotModel.fromJson(Map<String, dynamic> json) => _$SlotModelFromJson(json);
  Map<String, dynamic> toJson() => _$SlotModelToJson(this);
}

@JsonSerializable()
class DailySlotModel extends DailySlot {
  @JsonKey(name: 'slot_id')
  final String mappedSlotId;

  @JsonKey(name: 'venue_id')
  final String mappedVenueId;

  @JsonKey(name: 'slot_time')
  final String mappedSlotTime;

  const DailySlotModel({
    required this.mappedSlotId,
    required this.mappedVenueId,
    required super.date,
    required this.mappedSlotTime,
    required super.status,
  }) : super(slotId: mappedSlotId, venueId: mappedVenueId, slotTime: mappedSlotTime);

  factory DailySlotModel.fromJson(Map<String, dynamic> json) => _$DailySlotModelFromJson(json);
  Map<String, dynamic> toJson() => _$DailySlotModelToJson(this);
}
