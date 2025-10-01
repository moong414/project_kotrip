import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/pages/home/data/weather_repository.dart';
import 'package:project_kotrip/pages/home/model/weather_model.dart';

class WeatherViewModel extends Notifier<WeatherModel?> {
  final repository = WeatherRepository();

  @override
  WeatherModel? build() {
    return null; 
  }

  // 날씨 가져오기
  Future<void> fetchWeather(String lat, String lon) async {
    final weather = await repository.getWheather(lat, lon);
    state = weather;
  }
}

final weatherProvider = NotifierProvider<WeatherViewModel, WeatherModel?>(() => WeatherViewModel());
