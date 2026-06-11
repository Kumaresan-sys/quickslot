import 'package:flutter_test/flutter_test.dart';
import 'package:quickslot/data/repositories/venue_repository_impl.dart';

import 'package:quickslot/core/network/token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mock_api_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  group('VenueRepositoryImpl', () {
    final tokenStorage = TokenStorage();
    final apiClient = MockApiClient.create(tokenStorage);
    final repo = VenueRepositoryImpl(httpService: apiClient);

    test('getVenues returns a non‑empty list', () async {
      final venues = await repo.getVenues();
      expect(venues, isNotEmpty);
    });

    test('getVenueSlots returns slots for a venue and date', () async {
      final venues = await repo.getVenues();
      final venueId = venues.first.id;
      final slots = await repo.getVenueSlots(venueId, '2026-06-15');
      expect(slots, isNotEmpty);
    });
  });
}
