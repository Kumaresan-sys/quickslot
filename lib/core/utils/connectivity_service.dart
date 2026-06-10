import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Stream<bool> get isConnectedStream => _connectivity.onConnectivityChanged.map(
        (List<ConnectivityResult> result) => 
            result.isNotEmpty && result.first != ConnectivityResult.none,
      );

  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result.isNotEmpty && result.first != ConnectivityResult.none;
  }
}
