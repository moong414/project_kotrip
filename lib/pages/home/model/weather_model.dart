class WeatherModel {
  final String weather; 
  final double rain;       
  final DateTime getTime; 
  final String iconUrl;  

  WeatherModel({
    required this.weather,
    required this.rain,
    required this.getTime,
    required this.iconUrl,
  });

  WeatherModel copyWith({
    String? weather,
    double? rain,
    DateTime? getTime,
    String? iconUrl,
  }) {
    return WeatherModel(
      weather: weather ?? this.weather,
      rain: rain ?? this.rain,
      getTime: getTime ?? this.getTime,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }

  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    double precipitation = 0;
    if (map['precipitation'] != null &&
        map['precipitation']['probability'] != null &&
        map['precipitation']['probability']['percent'] != null) {
      precipitation =
          (map['precipitation']['probability']['percent'] as num).toDouble();
    }

    return WeatherModel(
      weather: map['weatherCondition']?['type'] ?? '',
      rain: precipitation,
      getTime: DateTime.parse(map['currentTime']),
      iconUrl: map['weatherCondition']?['iconBaseUri'] ?? '',
    );
  }
}


//아이콘 필요없을떄
// class WeatherModel {
//   final String weather; // 날씨 상태 (Cloudy, Sunny 등)
//   final double rain; // 강수확률(%)
//   final DateTime getTime; // 가져온 시간

//   WeatherModel({
//     required this.weather,
//     required this.rain,
//     required this.getTime,
//   });

//   WeatherModel copyWith({String? weather, double? rain, DateTime? getTime}) {
//     return WeatherModel(
//       weather: weather ?? this.weather,
//       rain: rain ?? this.rain,
//       getTime: getTime ?? this.getTime,
//     );
//   }

//   factory WeatherModel.fromMap(Map<String, dynamic> map) {
//     double precipitation = 0; // 강수확률이 없으면 0
//     if (map['precipitation'] != null &&
//         map['precipitation']['probability'] != null &&
//         map['precipitation']['probability']['percent'] != null) {
//       precipitation = (map['precipitation']['probability']['percent'] as num)
//           .toDouble();
//     }

//     return WeatherModel(
//       weather: map['weatherCondition']?['type'] ?? '',
//       rain: precipitation,
//       getTime: DateTime.parse(map['currentTime']),
//     );
//   }
// }
