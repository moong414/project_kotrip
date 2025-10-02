class WeatherModel {
  final double temperature;
  final double pop;
  final String sky;

  WeatherModel({
    required this.temperature,
    required this.pop,
    required this.sky,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: double.parse(json['T1H']),
      pop: double.parse(json['POP']),       
      sky: json['SKY'],                    
    );
  }
}
