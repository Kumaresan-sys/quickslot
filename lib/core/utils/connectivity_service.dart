import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectivityChecker {
  Stream<bool> get isConnectedStream;
  Future<bool> get isConnected;
}

class ConnectivityService implements ConnectivityChecker {
  final Connectivity connectivity;

  ConnectivityService({Connectivity? connectivity})
    : connectivity = connectivity ?? Connectivity();

  @override
  Stream<bool> get isConnectedStream => connectivity.onConnectivityChanged.map(
    (List<ConnectivityResult> result) => _hasNetwork(result),
  );

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return _hasNetwork(result);
  }

  bool _hasNetwork(List<ConnectivityResult> result) {
    return result.any((connection) => connection != ConnectivityResult.none);
  }
}

class AlwaysConnectedChecker implements ConnectivityChecker {
  const AlwaysConnectedChecker();

  @override
  Stream<bool> get isConnectedStream => const Stream<bool>.empty();

  @override
  Future<bool> get isConnected async => true;
}
