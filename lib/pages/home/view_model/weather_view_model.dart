import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/pages/home/data/weather_repository.dart';
import 'package:project_kotrip/pages/home/model/weather_model.dart';

final weatherProvider = NotifierProvider<WeatherNotifier, WeatherModel?>(
  () => WeatherNotifier(),
);

class WeatherNotifier extends Notifier<WeatherModel?> {
  final repo = WeatherRepository();

  @override
  WeatherModel? build() {
    return null; // 초기값
  }

  Future<void> fetchWeather(double latitude, double longitude) async {
    final weather = await repo.getWeather(latitude, longitude);
    state = weather;
  }
}
