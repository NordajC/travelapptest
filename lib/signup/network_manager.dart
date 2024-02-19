import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NetworkManager extends GetxController{
  static NetworkManager get instance => Get.find();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final Rx<ConnectivityResult> _connectionStatus = ConnectivityResult.none.obs;

  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectionStatus.value = result;
    if(result == ConnectivityResult.none){
      //no internet warning snack bar
      Get.snackbar(
        'No Internet Connection', // Title of the Snackbar
        'Please check your internet connection.', // Message of the Snackbar
        snackPosition: SnackPosition.BOTTOM, // Position of the Snackbar
        backgroundColor: Colors.orange, // Background color of the Snackbar
        shouldIconPulse: true, // Make the Snack bar icon pulse
        isDismissible: true, // Snack bar is dismissible
        colorText: Colors.white, // Text color
        icon: Icon(Icons.warning, color: Colors.white), // Icon to show on the Snackbar
        duration: Duration(seconds: 3), // Duration that the Snackbar will be shown
      );
    }
  }

  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if(result == ConnectivityResult.none){
        return false;
      }
      else{
        return true;
      }
    }
    on PlatformException catch (_) {
    return false;
  }
  } 

  @override
  void onClose() {
    super.onClose();
    _connectivitySubscription.cancel();
  }

}