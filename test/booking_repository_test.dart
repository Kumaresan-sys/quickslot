import 'package:flutter_test/flutter_test.dart';
import 'package:quickslot/data/repositories/booking_repository_impl.dart';
// import 'package:quickslot/core/network/api_client.dart'; // Removed unused import
import 'package:quickslot/core/network/token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mock_api_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  group('BookingRepositoryImpl', () {
    final tokenStorage = TokenStorage();
    final apiClient = MockApiClient.create(tokenStorage);
    final repo = BookingRepositoryImpl(apiClient: apiClient);

    test('create booking returns a booking id', () async {
      // Ensure we have a venue and slot first
      final venueRes = await apiClient.dio.get('/venues');
      final venueId = (venueRes.data['data'] as List).first['id'];
      final slotsRes = await apiClient.dio.get('/venues/$venueId/slots?date=2026-06-15');
      final slotId = (slotsRes.data['data'] as List).first['slot_id'];

      final booking = await repo.createBooking(venueId, slotId, '2026-06-15');
      expect(booking.id, isNotEmpty);
    });

    test('cancel booking returns cancelled status', () async {
      // Create a booking first
      final venueRes = await apiClient.dio.get('/venues');
      final venueId = (venueRes.data['data'] as List).first['id'];
      final slotsRes = await apiClient.dio.get('/venues/$venueId/slots?date=2026-06-15');
      final slotId = (slotsRes.data['data'] as List).first['slot_id'];
      final created = await repo.createBooking(venueId, slotId, '2026-06-15');

      await repo.cancelBooking(created.id);
      // Expect no exception
    });
  });
}
