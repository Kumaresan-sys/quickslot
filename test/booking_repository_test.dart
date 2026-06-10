import 'package:flutter_test/flutter_test.dart';
import 'package:quickslot/data/repositories/booking_repository_impl.dart';
import 'package:quickslot/core/network/api_client.dart';
import 'package:quickslot/core/network/token_storage.dart';

void main() {
  group('BookingRepositoryImpl', () {
    final tokenStorage = TokenStorage();
    final apiClient = ApiClient(baseUrl: 'http://10.0.2.2:5001', tokenStorage: tokenStorage);
    final repo = BookingRepositoryImpl(apiClient: apiClient);

    test('create booking returns a booking id', () async {
      // Ensure we have a venue and slot first
      final venueRes = await apiClient.get('/venues');
      final venueId = (venueRes['data'] as List).first['id'];
      final slotsRes = await apiClient.get('/venues/$venueId/slots?date=2026-06-15');
      final slotId = (slotsRes['data'] as List).first['slot_id'];

      final booking = await repo.createBooking(venueId: venueId, slotId: slotId, bookingDate: '2026-06-15');
      expect(booking.id, isNotEmpty);
    });

    test('cancel booking returns cancelled status', () async {
      // Create a booking first
      final venueRes = await apiClient.get('/venues');
      final venueId = (venueRes['data'] as List).first['id'];
      final slotsRes = await apiClient.get('/venues/$venueId/slots?date=2026-06-15');
      final slotId = (slotsRes['data'] as List).first['slot_id'];
      final created = await repo.createBooking(venueId: venueId, slotId: slotId, bookingDate: '2026-06-15');

      final cancelled = await repo.cancelBooking(bookingId: created.id);
      expect(cancelled.status, equals('CANCELLED'));
    });
  });
}
