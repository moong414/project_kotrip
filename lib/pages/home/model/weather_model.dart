class WeatherModel {
  final double temperature;
  final int weathercode;
  final DateTime time;
  final double rain;

  WeatherModel({
    required this.temperature,
    required this.weathercode,
    required this.time,
    required this.rain,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: (json['temperature'] as num).toDouble(),
      weathercode: json['weathercode'] as int,
      time: DateTime.parse(json['time'] as String),
      rain: (json['rain'] as num).toDouble(),
    );
  }

  String get sky {
    switch (weathercode) {
      case 0:
        return '맑음';
      case 1:
      case 2:
        return '부분적 구름';
      case 3:
        return '흐림';
      case 61:
      case 63:
      case 65:
        return '비';
      case 71:
      case 73:
      case 75:
        return '눈';
      default:
        return '알 수 없음';
    }
  }
}
