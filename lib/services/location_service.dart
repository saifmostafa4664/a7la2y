import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Returns true if device GPS / location services are turned on.
  static Future<bool> isGpsEnabled() async {
    return Geolocator.isLocationServiceEnabled();
  }

  /// Requests location permission. Returns true if granted.
  static Future<bool> requestLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  /// Gets the current device coordinates. Returns null if permission
  /// is not granted or an error occurs.
  static Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        return null;
      }

      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      );

      return await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );
    } catch (_) {
      return null;
    }
  }
}
