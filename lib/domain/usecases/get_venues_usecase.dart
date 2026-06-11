import '../entities/venue.dart';
import '../repositories/venue_repository.dart';

abstract class GetVenues {
  Future<List<Venue>> call();
}

class GetVenuesUseCase implements GetVenues {
  final VenueRepository repository;

  GetVenuesUseCase(this.repository);

  @override
  Future<List<Venue>> call() async {
    return await repository.getVenues();
  }
}
