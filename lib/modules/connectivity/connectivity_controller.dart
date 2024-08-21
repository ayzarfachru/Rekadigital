import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';

class ConnectivityController extends GetxController {
  var isConnected = false.obs;
  var isLoading = true.obs;

  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  void startConnectivityCheck() {
    _checkConnectivity();
    Timer.periodic(const Duration(seconds: 1), (_) => _checkConnectivity());
  }

  void _checkConnectivity() async {
    final _isConnected = await _hasInternetConnection();
    if (_isConnected != isConnected.value) {
      isConnected.value = _isConnected;
      if (isConnected.value) {
        Get.offAllNamed('/');
        print('Connected to the internet!');
      } else {
        Get.toNamed('/check_connectivity');
        print('No internet connection.');
      }
    }
    Timer.periodic(const Duration(seconds: 3), (_) => isLoading(false));
  }
}