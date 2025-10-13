import 'package:dio/dio.dart';
import 'package:project_kotrip/pages/home/model/weather_model.dart';

class WeatherRepository {
  final dio = Dio();

  Future<WeatherModel?> getWeather(double latitude, double longitude) async {
    final url = 'https://api.open-meteo.com/v1/forecast';

    try {
      final response = await dio.get(url, queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'current_weather': true,
        'hourly': 'precipitation_probability',
        'timezone': 'Asia/Seoul',
      });

      if (response.statusCode == 200) {
        final current = response.data['current_weather'];
        final hourly = response.data['hourly'];

        // 현재 시간 기준 강수확률 가져오기
        final currentTime = current['time'];
        final timeIndex = hourly['time'].indexOf(currentTime);
        final rain = timeIndex != -1 ? (hourly['precipitation_probability'][timeIndex] as num).toDouble() : 0.0;

        return WeatherModel.fromJson({
          'temperature': current['temperature'],
          'weathercode': current['weathercode'],
          'time': current['time'],
          'rain': rain,
        });
      } else {
        print('getWeather 에러: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('getWeather 에러: $e');
      return null;
    }
  }
}
