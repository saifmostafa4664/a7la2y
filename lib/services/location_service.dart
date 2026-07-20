import 'dart:developer' as developer;

import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Request location permission from user
  static Future<bool> requestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        // User permanently denied - open settings
        return false;
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        return true;
      }

      return false;
    } catch (e) {
      developer.log('Error requesting location permission: $e',
          name: 'LocationService');
      return false;
    }
  }

  /// Get current device position
  static Future<Position?> getCurrentPosition() async {
    try {
      // Check permission first
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        developer.log('Location permissions are permanently denied.',
            name: 'LocationService');
        return null;
      }

      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        developer.log('Location permission not granted.',
            name: 'LocationService');
        return null;
      }

      // Check if location services are enabled
      bool isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        developer.log('Location services are disabled.',
            name: 'LocationService');
        return null;
      }

      // Get current position using LocationSettings (non-deprecated API)
      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );

      final position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      return position;
    } catch (e) {
      developer.log('Error getting current position: $e',
          name: 'LocationService');
      return null;
    }
  }

  /// Get last known position (faster, may be outdated)
  static Future<Position?> getLastKnownPosition() async {
    try {
      final position = await Geolocator.getLastKnownPosition();
      return position;
    } catch (e) {
      developer.log('Error getting last known position: $e',
          name: 'LocationService');
      return null;
    }
  }

  /// Stream of position updates
  static Stream<Position> getPositionStream({
    int intervalDuration = 5,
    int distanceFilter = 10,
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter,
      ),
    );
  }

  /// Open location settings
  static Future<bool> openLocationSettings() {
    return Geolocator.openLocationSettings();
  }

  /// Open app settings
  static Future<bool> openAppSettings() {
    return Geolocator.openAppSettings();
  }

  /// Calculate distance between two coordinates in meters
  static double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }
}
