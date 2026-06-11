import '../entities/slot.dart';
import '../repositories/venue_repository.dart';

abstract class GetSlots {
  Future<List<DailySlot>> call(
    String venueId,
    String date, {
    String? startTime,
    String? endTime,
  });
}

class GetSlotsUseCase implements GetSlots {
  final VenueRepository repository;

  GetSlotsUseCase(this.repository);

  @override
  Future<List<DailySlot>> call(
    String venueId,
    String date, {
    String? startTime,
    String? endTime,
  }) async {
    return await repository.getVenueSlots(
      venueId,
      date,
      startTime: startTime,
      endTime: endTime,
    );
  }
}
