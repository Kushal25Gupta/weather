import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weather/utilities/constants.dart';

class Location {
  late double latitude;
  late double longitude;

  Future<bool> getCurrentLocation() async {
    try {
      final currentPosition = await _determinePosition();
      if (currentPosition == null) {
        return true;
      }
      latitude = currentPosition.latitude;
      longitude = currentPosition.longitude;
      return false;
    } catch (e) {
      return true;
    }
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showErrorSnackBar(kPermissionDisabled);
      await Future.delayed(const Duration(seconds: 2));
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showErrorSnackBar(kPermissionDenied);
        await Future.delayed(const Duration(seconds: 2));
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return null;
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }
}

void showErrorSnackBar(String msg) {
  Get.snackbar(
    "Error in location permission",
    msg,
    backgroundColor: Colors.red,
    colorText: Colors.white,
    duration: Duration(seconds: 2),
    snackPosition: SnackPosition.BOTTOM,
  );
}
