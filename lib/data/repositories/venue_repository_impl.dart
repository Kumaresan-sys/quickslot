import '../../core/network/api_endpoints.dart';
import '../../core/network/http_service.dart';
import '../../domain/entities/slot.dart';
import '../../domain/entities/venue.dart';
import '../../domain/repositories/venue_repository.dart';
import '../models/venue_model.dart';
import '../models/slot_model.dart';

class VenueRepositoryImpl implements VenueRepository {
  final HttpService httpService;

  VenueRepositoryImpl({required this.httpService});

  @override
  Future<List<Venue>> getVenues() async {
    final response = await httpService.get(ApiEndpoints.venues);
    final data = response['data'] as List;
    return data.map((json) => VenueModel.fromJson(json)).toList();
  }

  @override
  Future<List<DailySlot>> getVenueSlots(
    String venueId,
    String date, {
    String? startTime,
    String? endTime,
  }) async {
    final queryParams = {'date': date};
    if (startTime != null) queryParams['startTime'] = startTime;
    if (endTime != null) queryParams['endTime'] = endTime;

    final response = await httpService.get(
      ApiEndpoints.venueSlots(venueId),
      queryParameters: queryParams,
    );
    final data = response['data'] as List;
    return data.map((json) {
      if (json is Map<String, dynamic>) {
        json['date'] = date;
        json['venue_id'] = venueId;
      }
      return DailySlotModel.fromJson(json as Map<String, dynamic>);
    }).toList();
  }
}
