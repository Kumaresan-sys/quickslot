import 'package:flutter_test/flutter_test.dart';
import 'package:quickslot/data/repositories/venue_repository_impl.dart';
import 'package:quickslot/core/network/api_client.dart';
import 'package:quickslot/core/network/token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  group('VenueRepositoryImpl', () {
    final tokenStorage = TokenStorage();
    final apiClient = ApiClient(baseUrl: 'http://10.0.2.2:5001', tokenStorage: tokenStorage);
    final repo = VenueRepositoryImpl(apiClient: apiClient);

    test('fetch venues returns a non‑empty list', () async {
      final venues = await repo.getVenues();
      expect(venues, isNotEmpty);
    });

    test('fetch slots returns slots for a venue and date', () async {
      final venues = await repo.getVenues();
      final venueId = venues.first.id;
      final slots = await repo.getVenueSlots(venueId, '2026-06-15');
      expect(slots, isNotEmpty);
    });
  });
}
