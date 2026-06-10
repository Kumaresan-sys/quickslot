// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueModel _$VenueModelFromJson(Map<String, dynamic> json) => VenueModel(
  id: json['id'] as String,
  name: json['name'] as String,
  location: json['location'] as String,
);

Map<String, dynamic> _$VenueModelToJson(VenueModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
    };
