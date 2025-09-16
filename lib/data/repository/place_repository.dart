import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_kotrip/data/model/place_model.dart';

class PlaceRepository {
  final dio = Dio();
  final key = Uri.decodeFull(dotenv.env['TOUR_API_KEY'] ?? '');
  final url = 'https://apis.data.go.kr/B551011/KorService2/areaBasedList2?';

  Future<List<PlaceModel>> fetchPlaceList(String areaCode) async {
    try {
      final response = await dio.get(
        url,
        queryParameters: {
          'MobileOS': 'AND',
          'MobileApp': 'Kotrip',
          'serviceKey': key,
          'areaCode': areaCode,
          'contentTypeId': '12',
          //12관광지 14문화시설 39음식점
          // 'pageNo': '1',
          // 'numOfRows': '10',
          '_type': 'json',
        },
      );

      if (response.statusCode == 200) {
        final placeData = response.data['response']['body']['items']['item'];
        List<PlaceModel> placeList = [];

        if (placeData == null) {
        } else if (placeData is List) {
          placeList =
              placeData
                  .map((e) => PlaceModel.fromJson(Map<String, dynamic>.from(e)))
                  .where((place) => place.firstimage.isNotEmpty)
                  .toList()
                ..shuffle();
        } else if (placeData is Map) {
          placeList = [
            PlaceModel.fromJson(Map<String, dynamic>.from(placeData)),
          ].where((place) => place.firstimage.isNotEmpty).toList();
        }

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
