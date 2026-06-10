import '../../core/network/api_client.dart';
import '../../domain/entities/slot.dart';
import '../../domain/entities/venue.dart';
import '../../domain/repositories/venue_repository.dart';
import '../models/venue_model.dart';
import '../models/slot_model.dart';

class VenueRepositoryImpl implements VenueRepository {
  final ApiClient apiClient;

  VenueRepositoryImpl({required this.apiClient});

  @override
  Future<List<Venue>> getVenues() async {
    final response = await apiClient.dio.get('/venues');
    final data = response.data['data'] as List;
    return data.map((json) => VenueModel.fromJson(json)).toList();
  }

  @override
  Future<List<DailySlot>> getVenueSlots(String venueId, String date, {String? startTime, String? endTime}) async {
    final queryParams = {'date': date};
    if (startTime != null) queryParams['startTime'] = startTime;
    if (endTime != null) queryParams['endTime'] = endTime;

    final response = await apiClient.dio.get('/venues/$venueId/slots', queryParameters: queryParams);
    final data = response.data['data'] as List;
    return data.map((json) => DailySlotModel.fromJson(json)).toList();
  }
}
