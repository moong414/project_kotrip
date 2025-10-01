
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_kotrip/pages/home/model/weather_model.dart';

class WeatherRepository {
  final dio = Dio();
  final key = Uri.decodeFull(dotenv.env['GOOGLE_API_KEY'] ?? '');
  final Url = 'https://weather.googleapis.com/v1/currentConditions:lookup?';

  //현재상태가져오기
  Future<WeatherModel?> getWheather(String y, String x) async {
    try {
      final response = await dio.post(
        Url,
        queryParameters: {
          'key': key,
          'location.latitude': y,
          'location.longitude': x,
        }
      );
      if (response.statusCode == 200) {
        final result = WeatherModel.fromMap(Map<String, dynamic>.from(response as Map));
        return result;
      } else {
        print('getWheather 에러');
        return null;
      }
    } catch (e) {
      print('getWheather 에러: $e');
      return null;
    }
  }

  
}

// {
//   "currentTime": "2025-10-01T11:56:56.235707232Z",
//   "timeZone": {
//     "id": "America/Los_Angeles"
//   },
//   "isDaytime": false,
//   "weatherCondition": {
//     "iconBaseUri": "https://maps.gstatic.com/weather/v1/cloudy",
//     "description": {
//       "text": "Cloudy",
//       "languageCode": "en"
//     },
//     "type": "CLOUDY"
//   },
//   "temperature": {
//     "degrees": 17.7,
//     "unit": "CELSIUS"
//   },
//   "feelsLikeTemperature": {
//     "degrees": 17.7,
//     "unit": "CELSIUS"
//   },
//   "dewPoint": {
//     "degrees": 13.7,
//     "unit": "CELSIUS"
//   },
//   "heatIndex": {
//     "degrees": 17.7,
//     "unit": "CELSIUS"
//   },
//   "windChill": {
//     "degrees": 17.7,
//     "unit": "CELSIUS"
//   },
//   "relativeHumidity": 78,
//   "uvIndex": 0,
//   "precipitation": {
//     "probability": {
//       "percent": 25,
//       "type": "RAIN"
//     },
//     "snowQpf": {
//       "quantity": 0,
//       "unit": "MILLIMETERS"
//     },
//     "qpf": {
//       "quantity": 0,
//       "unit": "MILLIMETERS"
//     }
//   },
//   "thunderstormProbability": 0,
//   "airPressure": {
//     "meanSeaLevelMillibars": 1016.62
//   },
//   "wind": {
//     "direction": {
//       "degrees": 180,
//       "cardinal": "SOUTH"
//     },
//     "speed": {
//       "value": 6,
//       "unit": "KILOMETERS_PER_HOUR"
//     },
//     "gust": {
//       "value": 9,
//       "unit": "KILOMETERS_PER_HOUR"
//     }
//   },
//   "visibility": {
//     "distance": 16,
//     "unit": "KILOMETERS"
//   },
//   "cloudCover": 90,
//   "currentConditionsHistory": {
//     "temperatureChange": {
//       "degrees": -0.9,
//       "unit": "CELSIUS"
//     },
//     "maxTemperature": {
//       "degrees": 23.4,
//       "unit": "CELSIUS"
//     },
//     "minTemperature": {
//       "degrees": 16.9,
//       "unit": "CELSIUS"
//     },
//     "snowQpf": {
//       "quantity": 0,
//       "unit": "MILLIMETERS"
//     },
//     "qpf": {
//       "quantity": 0,
//       "unit": "MILLIMETERS"
//     }
//   }
// }
