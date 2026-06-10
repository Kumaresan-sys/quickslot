import 'package:equatable/equatable.dart';

class Venue extends Equatable {
  final String id;
  final String name;
  final String location;

  const Venue({
    required this.id,
    required this.name,
    required this.location,
  });

  @override
  List<Object?> get props => [id, name, location];
}
