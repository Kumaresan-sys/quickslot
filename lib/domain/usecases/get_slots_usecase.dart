import '../entities/slot.dart';
import '../repositories/venue_repository.dart';

class GetSlotsUseCase {
  final VenueRepository repository;

  GetSlotsUseCase(this.repository);

  Future<List<DailySlot>> call(String venueId, String date, {String? startTime, String? endTime}) async {
    return await repository.getVenueSlots(venueId, date, startTime: startTime, endTime: endTime);
  }
}
