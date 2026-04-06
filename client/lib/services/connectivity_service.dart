import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity() {
    _subscription = _connectivity.onConnectivityChanged.listen((_) => _emit());
    _emit();
  }

  final Connectivity _connectivity;
  late final StreamController<bool> _controller = StreamController<bool>.broadcast();
  late final StreamSubscription _subscription;

  Stream<bool> get isOnline => _controller.stream;

  Future<void> _emit() async {
    final result = await _connectivity.checkConnectivity();
    final online = result != ConnectivityResult.none;
    _controller.add(online);
  }

  Future<void> dispose() async {
    await _subscription.cancel();
    await _controller.close();
  }
}

