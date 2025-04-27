import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ConnectivityService with ChangeNotifier {
  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((result) {
      _connectivityResult = result;
      notifyListeners();
    });
  }

  List<ConnectivityResult> _connectivityResult = [ConnectivityResult.none];
  List<ConnectivityResult> get connectivityResult => _connectivityResult;
  bool get isConnected => _connectivityResult[0] != ConnectivityResult.none;
  Future<void> checkConnectivity() async {
    _connectivityResult = await Connectivity().checkConnectivity();
    notifyListeners();
  }

  Future<bool> isInternetWorking() async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}
