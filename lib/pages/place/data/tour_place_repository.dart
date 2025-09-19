import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_kotrip/pages/place/data/place_model.dart';

class TourPlaceRepository {
  final dio = Dio();
  final key = Uri.decodeFull(dotenv.env['TOUR_API_KEY'] ?? '');
  final url = 'https://apis.data.go.kr/B551011/KorService2/areaBasedList2?';

  Future<List<PlaceModel>> fetchPlaceList({required String areaCode, String? contentTypeId}) async {
    try {
      final response = await dio.get(
        url,
        queryParameters: {
          'MobileOS': 'AND',
          'MobileApp': 'Kotrip',
          'serviceKey': key,
          'areaCode': areaCode,
          if (contentTypeId != null) 'contentTypeId': contentTypeId,
          //12관광지 14문화시설 39음식점
          // 'pageNo': '1',
          'numOfRows': '10',
          '_type': 'json',
          'arrange': 'Q'
          //O=제목순, Q=수정일순, R=생성일순
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


// {
//   "response": {
//     "header": {
//       "resultCode": "0000",
//       "resultMsg": "OK"
//     },
//     "body": {
//       "items": {
//         "item": [
//           {
//             "addr1": "서울특별시 종로구 북촌로 57 (가회동)",
//             "addr2": "",
//             "areacode": "1",
//             "cat1": "A02",
//             "cat2": "A0201",
//             "cat3": "A02010900",
//             "contentid": "2733967",
//             "contenttypeid": "12",
//             "createdtime": "20210817184103",
//             "firstimage": "http://tong.visitkorea.or.kr/cms/resource/09/3303909_image2_1.jpg",
//             "firstimage2": "http://tong.visitkorea.or.kr/cms/resource/09/3303909_image3_1.jpg",
//             "cpyrhtDivCd": "Type3",
//             "mapx": "126.9846616856",
//             "mapy": "37.5820858828",
//             "mlevel": "6",
//             "modifiedtime": "20250312152659",
//             "sigungucode": "23",
//             "tel": "",
//             "title": "가회동성당",
//             "zipcode": "03052",
//             "lDongRegnCd": "11",
//             "lDongSignguCd": "110",
//             "lclsSystm1": "HS",
//             "lclsSystm2": "HS03",
//             "lclsSystm3": "HS030200"
//           },
//           {
//             "addr1": "서울특별시 동대문구 서울시립대로2길 59 (답십리동)",
//             "addr2": "",
//             "areacode": "1",
//             "cat1": "A02",
//             "cat2": "A0202",
//             "cat3": "A02020700",
//             "contentid": "2763807",
//             "contenttypeid": "12",
//             "createdtime": "20211027233001",
//             "firstimage": "http://tong.visitkorea.or.kr/cms/resource/80/3505480_image2_1.jpg",
//             "firstimage2": "http://tong.visitkorea.or.kr/cms/resource/80/3505480_image3_1.jpg",
//             "cpyrhtDivCd": "Type1",
//             "mapx": "127.0490783005",
//             "mapy": "37.5728353382",
//             "mlevel": "6",
//             "modifiedtime": "20250711160959",
//             "sigungucode": "11",
//             "tel": "",
//             "title": "간데메공원",
//             "zipcode": "02595",
//             "lDongRegnCd": "11",
//             "lDongSignguCd": "230",
//             "lclsSystm1": "VE",
//             "lclsSystm2": "VE03",
//             "lclsSystm3": "VE030100"
//           },