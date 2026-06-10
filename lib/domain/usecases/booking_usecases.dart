import '../entities/booking.dart';
import '../repositories/booking_repository.dart';

class BookSlotUseCase {
  final BookingRepository repository;

  BookSlotUseCase(this.repository);

  Future<Booking> call(String venueId, String slotId, String date) async {
    return await repository.createBooking(venueId, slotId, date);
  }
}

class CancelBookingUseCase {
  final BookingRepository repository;

  CancelBookingUseCase(this.repository);

  Future<void> call(String bookingId) async {
    return await repository.cancelBooking(bookingId);
  }
}

class GetUserBookingsUseCase {
  final BookingRepository repository;

  GetUserBookingsUseCase(this.repository);

  Future<List<Booking>> call(String userId) async {
    return await repository.getUserBookings(userId);
  }
}
