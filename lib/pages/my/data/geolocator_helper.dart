import 'package:geolocator/geolocator.dart';

class GeolocatorHelper {
  static bool _isDenied(LocationPermission permission) {
    return permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever;
  }

  static Future<Position?> getPositon() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('위치 서비스가 꺼져있습니다.');
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (_isDenied(permission)) {
        permission = await Geolocator.requestPermission();
        if (_isDenied(permission)) {
          print('위치 권한이 거부되었습니다.');
          return null;
        }
      }

      final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      );

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );
      return position;
    } catch (e) {
      print('GPS 오류 발생: $e');
      return null;
    }
  }
}
