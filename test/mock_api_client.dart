import 'package:dio/dio.dart';
import 'package:quickslot/core/network/api_endpoints.dart';
import 'package:quickslot/core/network/api_client.dart';
import 'package:quickslot/core/network/token_storage.dart';

/// A simple mock implementation of [ApiClient] that returns predefined
/// responses for the endpoints used in the unit tests. It does **not** make
/// any real network calls.
class MockApiClient extends ApiClient {
  MockApiClient({required TokenStorage tokenStorage})
    : super(baseUrl: '', tokenStore: tokenStorage, dio: Dio()) {
    // Intercept all requests and provide canned responses.
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final path = options.path.split('?').first;

          // Helper to create a successful JSON response.
          Response mockResponse(Map<String, dynamic> data) =>
              Response(requestOptions: options, statusCode: 200, data: data);

          // Mock data for each endpoint used in tests.
          if (path == ApiEndpoints.authLogin && options.method == 'POST') {
            return handler.resolve(
              mockResponse({
                'data': {
                  'accessToken': 'mockAccess',
                  'refreshToken': 'mockRefresh',
                  'user': {
                    'id': 'user1',
                    'email': 'test@example.com',
                    'name': 'Test User',
                  },
                },
              }),
            );
          }

          if (path == ApiEndpoints.authRefresh && options.method == 'POST') {
            return handler.resolve(
              mockResponse({
                'data': {
                  'accessToken': 'mockAccessRefreshed',
                  'refreshToken': 'mockRefreshRefreshed',
                },
              }),
            );
          }

          if (path == ApiEndpoints.venues && options.method == 'GET') {
            return handler.resolve(
              mockResponse({
                'data': [
                  {
                    'id': 'venue1',
                    'name': 'Venue One',
                    'location': 'Location One',
                  },
                  {
                    'id': 'venue2',
                    'name': 'Venue Two',
                    'location': 'Location Two',
                  },
                ],
              }),
            );
          }

          // Slots endpoint: /venues/{venueId}/slots?date=2026-06-15
          if (path.endsWith(ApiEndpoints.slotsSuffix) &&
              options.method == 'GET') {
            return handler.resolve(
              mockResponse({
                'data': [
                  {
                    'slot_id': 'slot1',
                    'date': '2026-06-15',
                    'status': 'AVAILABLE',
                  },
                  {
                    'slot_id': 'slot2',
                    'date': '2026-06-15',
                    'status': 'AVAILABLE',
                  },
                ],
              }),
            );
          }

          if (path == ApiEndpoints.bookings && options.method == 'POST') {
            return handler.resolve(
              mockResponse({
                'data': {
                  'id': 'booking1',
                  'user_id': 'user1',
                  'venue_id': 'venue1',
                  'slot_id': 'slot1',
                  'booking_date': '2026-06-15',
                  'status': 'BOOKED',
                  'created_at': '2026-06-11T10:00:00.000Z',
                },
              }),
            );
          }

          if (path.startsWith('${ApiEndpoints.bookings}/') &&
              options.method == 'DELETE') {
            return handler.resolve(
              mockResponse({
                'data': {'status': 'CANCELLED'},
              }),
            );
          }

          // Default: return an empty 200 response.
          return handler.resolve(mockResponse({'data': []}));
        },
      ),
    );
  }

  /// Convenience factory used in the tests.
  static MockApiClient create(TokenStorage tokenStorage) =>
      MockApiClient(tokenStorage: tokenStorage);
}
