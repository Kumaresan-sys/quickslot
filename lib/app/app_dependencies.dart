import '../core/config/app_config.dart';
import '../core/network/api_client.dart';
import '../core/network/auth_token_refresher.dart';
import '../core/network/socket_client.dart';
import '../core/network/token_storage.dart';
import '../core/utils/connectivity_service.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/booking_repository_impl.dart';
import '../data/repositories/venue_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/booking_repository.dart';
import '../domain/repositories/venue_repository.dart';
import '../domain/services/booking_failure_classifier.dart';

class AppDependencies {
  final TokenStore tokenStore;
  final ApiClient apiClient;
  final ConnectivityChecker connectivityChecker;
  final SocketClient socketClient;
  final AuthRepository authRepository;
  final VenueRepository venueRepository;
  final BookingRepository bookingRepository;
  final BookingFailureClassifier bookingFailureClassifier;

  AppDependencies._({
    required this.tokenStore,
    required this.apiClient,
    required this.connectivityChecker,
    required this.socketClient,
    required this.authRepository,
    required this.venueRepository,
    required this.bookingRepository,
    required this.bookingFailureClassifier,
  });

  factory AppDependencies.create({
    required AppConfig config,
    bool connectSocket = true,
  }) {
    config.validate();

    final tokenStore = TokenStorage();
    final connectivityChecker = ConnectivityService();
    final tokenRefresher = AuthTokenRefresher(
      baseUrl: config.apiBaseUrl,
      tokenStore: tokenStore,
    );
    final apiClient = ApiClient(
      baseUrl: config.apiBaseUrl,
      tokenStore: tokenStore,
      connectivityChecker: connectivityChecker,
      tokenRefresher: tokenRefresher,
    );
    final socketClient = SocketClient(url: config.socketUrl);
    if (connectSocket) {
      socketClient.connect();
    }

    return AppDependencies._(
      tokenStore: tokenStore,
      apiClient: apiClient,
      connectivityChecker: connectivityChecker,
      socketClient: socketClient,
      authRepository: AuthRepositoryImpl(
        httpService: apiClient,
        tokenStore: tokenStore,
      ),
      venueRepository: VenueRepositoryImpl(httpService: apiClient),
      bookingRepository: BookingRepositoryImpl(httpService: apiClient),
      bookingFailureClassifier: const ApiBookingFailureClassifier(),
    );
  }

  void dispose() {
    socketClient.dispose();
  }
}
