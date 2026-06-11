import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickslot/core/network/api_client.dart';
import 'package:quickslot/core/network/token_storage.dart';
import 'package:quickslot/core/utils/connectivity_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineConnectivityChecker implements ConnectivityChecker {
  const OfflineConnectivityChecker();

  @override
  Stream<bool> get isConnectedStream => Stream<bool>.value(false);

  @override
  Future<bool> get isConnected async => false;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ApiClient connectivity', () {
    test('rejects requests when device is offline', () async {
      SharedPreferences.setMockInitialValues({});
      final apiClient = ApiClient(
        baseUrl: '',
        tokenStore: TokenStorage(),
        connectivityChecker: const OfflineConnectivityChecker(),
      );

      await expectLater(
        apiClient.get('/venues'),
        throwsA(
          isA<DioException>().having(
            (error) => error.type,
            'type',
            DioExceptionType.connectionError,
          ),
        ),
      );
    });
  });
}
