import 'package:equatable/equatable.dart';
import '../../../domain/entities/slot.dart';

abstract class VenueDetailState extends Equatable {
  final String selectedDate;
  final List<DailySlot> slots;
  
  const VenueDetailState({required this.selectedDate, required this.slots});

  @override
  List<Object?> get props => [selectedDate, slots];
}

class VenueDetailInitial extends VenueDetailState {
  const VenueDetailInitial({required String date}) : super(selectedDate: date, slots: const []);
}

class VenueDetailLoading extends VenueDetailState {
  const VenueDetailLoading({required super.selectedDate, required super.slots});
}

class VenueDetailLoaded extends VenueDetailState {
  const VenueDetailLoaded({required super.selectedDate, required super.slots});
}

class VenueDetailEmpty extends VenueDetailState {
  const VenueDetailEmpty({required super.selectedDate}) : super(slots: const []);
}

class VenueDetailError extends VenueDetailState {
  final String message;
  const VenueDetailError({required super.selectedDate, required super.slots, required this.message});
  
  @override
  List<Object?> get props => [selectedDate, slots, message];
}

class BookingInProgress extends VenueDetailState {
  const BookingInProgress({required super.selectedDate, required super.slots});
}

class BookingSuccess extends VenueDetailState {
  final String bookingId;
  const BookingSuccess({required super.selectedDate, required super.slots, required this.bookingId});

  @override
  List<Object?> get props => [selectedDate, slots, bookingId];
}

class BookingConflict extends VenueDetailState {
  final String message;
  const BookingConflict({required super.selectedDate, required super.slots, required this.message});

  @override
  List<Object?> get props => [selectedDate, slots, message];
}
