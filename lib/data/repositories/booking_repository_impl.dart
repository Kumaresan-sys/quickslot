import '../../core/network/api_client.dart';
import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';
import '../models/booking_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final ApiClient apiClient;

  BookingRepositoryImpl({required this.apiClient});

  @override
  Future<List<Booking>> getUserBookings(String userId) async {
    final response = await apiClient.dio.get('/users/$userId/bookings');
    final data = response.data['data'] as List;
    return data.map((json) => BookingModel.fromJson(json)).toList();
  }

  @override
  Future<Booking> createBooking(String venueId, String slotId, String date) async {
    final response = await apiClient.dio.post('/bookings', data: {
      'venueId': venueId,
      'slotId': slotId,
      'bookingDate': date,
    });
    return BookingModel.fromJson(response.data['data']);
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await apiClient.dio.delete('/bookings/$bookingId');
  }
}
