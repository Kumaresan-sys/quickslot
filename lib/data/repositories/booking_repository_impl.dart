import '../../core/network/api_endpoints.dart';
import '../../core/network/http_service.dart';
import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';
import '../models/booking_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final HttpService httpService;

  BookingRepositoryImpl({required this.httpService});

  @override
  Future<List<Booking>> getUserBookings(String userId) async {
    final response = await httpService.get(ApiEndpoints.userBookings(userId));
    final data = response['data'] as List;
    return data.map((json) => BookingModel.fromJson(json)).toList();
  }

  @override
  Future<Booking> createBooking(
    String venueId,
    String slotId,
    String date,
  ) async {
    final response = await httpService.post(
      ApiEndpoints.bookings,
      data: {'venueId': venueId, 'slotId': slotId, 'bookingDate': date},
    );
    return BookingModel.fromJson(response['data']);
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await httpService.delete(ApiEndpoints.booking(bookingId));
  }
}
