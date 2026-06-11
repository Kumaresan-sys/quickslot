import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/booking.dart';
import '../../../domain/usecases/booking_usecases.dart';
import '../../utils/error_message_mapper.dart';

abstract class MyBookingsState extends Equatable {
  const MyBookingsState();
  @override
  List<Object?> get props => [];
}

class MyBookingsInitial extends MyBookingsState {}

class MyBookingsLoading extends MyBookingsState {}

class MyBookingsLoaded extends MyBookingsState {
  final List<Booking> bookings;
  const MyBookingsLoaded(this.bookings);
  @override
  List<Object?> get props => [bookings];
}

class MyBookingsEmpty extends MyBookingsState {}

class MyBookingsError extends MyBookingsState {
  final String message;
  const MyBookingsError(this.message);
  @override
  List<Object?> get props => [message];
}

class MyBookingsCubit extends Cubit<MyBookingsState> {
  final GetUserBookings getUserBookingsUseCase;
  final CancelBooking cancelBookingUseCase;

  MyBookingsCubit({
    required this.getUserBookingsUseCase,
    required this.cancelBookingUseCase,
  }) : super(MyBookingsInitial());

  Future<void> loadBookings(String userId) async {
    emit(MyBookingsLoading());
    try {
      final bookings = await getUserBookingsUseCase(userId);
      if (bookings.isEmpty) {
        emit(MyBookingsEmpty());
      } else {
        emit(MyBookingsLoaded(bookings));
      }
    } catch (e) {
      emit(MyBookingsError(ErrorMessageMapper.map(e)));
    }
  }

  Future<void> cancelBooking(String bookingId, String userId) async {
    final currentState = state;
    if (currentState is! MyBookingsLoaded) return;

    emit(MyBookingsLoading());
    try {
      await cancelBookingUseCase(bookingId);
      // Reload after successful cancel
      await loadBookings(userId);
    } catch (e) {
      // Revert to old state and emit error somehow or just show error state
      emit(MyBookingsError(ErrorMessageMapper.map(e)));
      emit(MyBookingsLoaded(currentState.bookings));
    }
  }
}
