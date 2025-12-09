import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_isConnected);
  }

  Future<bool> checkInternetConnection() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return _isConnected(connectivityResult);
    } catch (e) {
      return false;
    }
  }

  bool _isConnected(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }
}
