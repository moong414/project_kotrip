import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PlaceRepository {
  final dio = Dio();
  final key = dotenv.env['TOUR_API_KEY'];
  final url = 'https://apis.data.go.kr/B551011/KorService2/areaBasedList2?';

  Future<List<dynamic>> fetchPlaceList(
    String areaCode,
  ) async {
    try {
      final response = await dio.get(
        url,
        queryParameters: {
          'MobileOS': 'AND',
          'MobileApp': 'Kotrip',
          'serviceKey': key,
          'areaCode': areaCode,
          //'contentTypeId': contentType,
          //12관광지 14문화시설 39음식점
          'pageNo': '1',
          'numOfRows': '10',
          '_type': 'json',
        },
      );

      if (response.statusCode == 200) {
        final placeList =
            response.data['response']['body']['items']['item'] as List;
        return placeList;
      } else {
        return [];
      }
    } catch (e) {
      print('error발생!! $e');
      return [];
    }
  }
}
