import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class LocationService {
  static Future<bool> requestPermissions() async {
    await Permission.location.request();
    final granted = await Permission.location.isGranted;
    if (granted) {
      print('✅ Location permission granted');
    } else {
      print('❌ Location permission denied');
    }
    return granted;
  }

  static Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    );
  }

  static Future<Position?> getCurrentPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print('📍 Current position: ${position.latitude}, ${position.longitude}');
      return position;
    } catch (e) {
      print('❌ Location Error: $e');
      return null;
    }
  }
} 