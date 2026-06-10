import '../entities/booking.dart';

abstract class BookingRepository {
  Future<List<Booking>> getUserBookings(String userId);
  Future<Booking> createBooking(String venueId, String slotId, String date);
  Future<void> cancelBooking(String bookingId);
}
