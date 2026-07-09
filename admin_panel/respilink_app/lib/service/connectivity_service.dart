import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final _connectivity = Connectivity();

  Stream<bool> get isOnline => _connectivity.onConnectivityChanged
      .map((result) => result.first != ConnectivityResult.none);

  Future<bool> get currentlyOnline async {
    final result = await _connectivity.checkConnectivity();
    return result.first != ConnectivityResult.none;
  }
}