import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/pages/home/data/weather_repository.dart';
import 'package:project_kotrip/pages/home/model/weather_model.dart';


class WeatherViewModel extends Notifier<WeatherModel?> {
  final repository = WeatherRepository();

  @override
  WeatherModel? build() {
    return null; 
  }

  Future<void> fetchWeather(int nx, int ny, String baseDate, String baseTime) async {
    final weather = await repository.getWeather(nx, ny, baseDate, baseTime);
    state = weather;
  }
}

final weatherProvider = NotifierProvider<WeatherViewModel, WeatherModel?>(
  () => WeatherViewModel(),
);
