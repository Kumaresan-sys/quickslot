import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/venue.dart';

part 'venue_model.g.dart';

@JsonSerializable()
class VenueModel extends Venue {
  const VenueModel({
    required super.id,
    required super.name,
    required super.location,
  });

  factory VenueModel.fromJson(Map<String, dynamic> json) => _$VenueModelFromJson(json);
  Map<String, dynamic> toJson() => _$VenueModelToJson(this);
}
