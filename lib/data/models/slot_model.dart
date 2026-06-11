import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/slot.dart';

part 'slot_model.g.dart';

@JsonSerializable()
class SlotModel extends Slot {
  @JsonKey(name: 'venue_id')
  final String? mappedVenueId;

  @JsonKey(name: 'slot_time')
  final String? mappedSlotTime;

  const SlotModel({required super.id, this.mappedVenueId, this.mappedSlotTime})
    : super(venueId: mappedVenueId ?? '', slotTime: mappedSlotTime ?? '');

  factory SlotModel.fromJson(Map<String, dynamic> json) => SlotModel(
    id: (json['slot_id'] ?? json['id'] ?? '') as String,
    mappedVenueId: json['venue_id'] as String?,
    mappedSlotTime: json['slot_time'] as String?,
  );
  Map<String, dynamic> toJson() => _$SlotModelToJson(this);
}

@JsonSerializable()
class DailySlotModel extends DailySlot {
  @JsonKey(name: 'slot_id')
  final String? mappedSlotId;

  @JsonKey(name: 'venue_id')
  final String? mappedVenueId;

  @JsonKey(name: 'slot_time')
  final String? mappedSlotTime;

  @JsonKey(name: 'userId')
  final String? mappedHeldByUserId;

  const DailySlotModel({
    this.mappedSlotId,
    this.mappedVenueId,
    required super.date,
    this.mappedSlotTime,
    required super.status,
    this.mappedHeldByUserId,
  }) : super(
         slotId: mappedSlotId ?? '',
         venueId: mappedVenueId ?? '',
         slotTime: mappedSlotTime ?? '',
         heldByUserId: mappedHeldByUserId,
       );

  factory DailySlotModel.fromJson(Map<String, dynamic> json) => DailySlotModel(
    mappedSlotId: json['slot_id'] as String?,
    mappedVenueId: json['venue_id'] as String?,
    date: json['date'] as String? ?? '',
    mappedSlotTime: json['slot_time'] as String?,
    status: json['status'] as String? ?? 'AVAILABLE',
    mappedHeldByUserId: json['userId'] as String?,
  );
  Map<String, dynamic> toJson() => _$DailySlotModelToJson(this);
}
