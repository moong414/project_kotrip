import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_kotrip/pages/place/data/place_model.dart';

class TourPlaceRepository {
  final dio = Dio();
  final key = Uri.decodeFull(dotenv.env['TOUR_API_KEY'] ?? '');
  final url = 'https://apis.data.go.kr/B551011/KorService2/areaBasedList2?';

  Future<List<PlaceModel>> fetchPlaceList({
    required String areaCode,
    String? contentTypeId,
  }) async {
    try {
      final response = await dio.get(
        url,
        queryParameters: {
          'MobileOS': 'AND',
          'MobileApp': 'Kotrip',
          'serviceKey': key,
          'areaCode': areaCode,
          if (contentTypeId != null) 'contentTypeId': contentTypeId,
          //12관광지 14문화시설 39음식점 15행사/공연/축제 38쇼핑
          // 'pageNo': '1',
          'numOfRows': '10',
          '_type': 'json',
          'arrange': 'R',
          //O=제목순, Q=수정일순, R=생성일순
        },
        options: Options(
          responseType: ResponseType.json,
          validateStatus: (_) => true, // 500도 throw 안 하고 response로 받음
        ),
      );

      if (response.statusCode == 200) {
        final items = response.data['response']?['body']?['items']?['item'];
        List<PlaceModel> placeList = [];

        if (items == null) return [];

        if (items is List) {
          placeList =
              items
                  .map((e) => PlaceModel.fromJson(Map<String, dynamic>.from(e)))
                  .toList()
                ..shuffle();
        } else if (items is Map) {
          placeList = [PlaceModel.fromJson(Map<String, dynamic>.from(items))];
        } else {
          print('item이 예상치 못한 타입: ${items.runtimeType}');
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
