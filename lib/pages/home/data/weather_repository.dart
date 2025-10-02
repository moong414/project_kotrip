import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_kotrip/pages/home/model/weather_model.dart';

class WeatherRepository {
  final dio = Dio();
  final key = dotenv.env['KMA_API_KEY'] ?? '';

  Future<WeatherModel?> getWeather(int nx, int ny, String baseDate, String baseTime) async {
    final url = 'https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtFcst';

    try {
      final response = await dio.get(
        url,
        queryParameters: {
          'serviceKey': key,
          'numOfRows': '60',
          'pageNo': '1',
          'dataType': 'JSON',
          'base_date': baseDate,
          'base_time': baseTime,
          'nx': nx,
          'ny': ny,
        },
      );

      if (response.statusCode == 200) {
        final items = response.data['response']['body']['items']['item'] as List;
        // 가장 최근 데이터 가져오기
        final latest = items.last;
        return WeatherModel.fromJson(latest);
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
