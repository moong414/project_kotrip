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
      case 1:
        return 'clear';
      case 2:
        return 'partly_cloudy';
      case 3:
        return 'cloudy';
      case 45:
      case 48:
        return 'hail';
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
        return 'rain';
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return 'snow';            
      case 95:       
      case 96:
      case 99:
        return 'thunder_storm';    
      default:
        return 'default';
    }
  }
}
