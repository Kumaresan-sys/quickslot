import '../entities/slot.dart';
import '../entities/venue.dart';

abstract class VenueRepository {
  Future<List<Venue>> getVenues();
  Future<List<DailySlot>> getVenueSlots(String venueId, String date, {String? startTime, String? endTime});
}
