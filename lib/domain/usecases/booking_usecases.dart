import '../entities/booking.dart';
import '../repositories/booking_repository.dart';

abstract class BookSlot {
  Future<Booking> call(String venueId, String slotId, String date);
}

abstract class CancelBooking {
  Future<void> call(String bookingId);
}

abstract class GetUserBookings {
  Future<List<Booking>> call(String userId);
}

class BookSlotUseCase implements BookSlot {
  final BookingRepository repository;

  BookSlotUseCase(this.repository);

  @override
  Future<Booking> call(String venueId, String slotId, String date) async {
    return await repository.createBooking(venueId, slotId, date);
  }
}

class CancelBookingUseCase implements CancelBooking {
  final BookingRepository repository;

  CancelBookingUseCase(this.repository);

  @override
  Future<void> call(String bookingId) async {
    return await repository.cancelBooking(bookingId);
  }
}

class GetUserBookingsUseCase implements GetUserBookings {
  final BookingRepository repository;

  GetUserBookingsUseCase(this.repository);

  @override
  Future<List<Booking>> call(String userId) async {
    return await repository.getUserBookings(userId);
  }
}
