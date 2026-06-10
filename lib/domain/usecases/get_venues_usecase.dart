import '../entities/venue.dart';
import '../repositories/venue_repository.dart';

class GetVenuesUseCase {
  final VenueRepository repository;

  GetVenuesUseCase(this.repository);

  Future<List<Venue>> call() async {
    return await repository.getVenues();
  }
}
