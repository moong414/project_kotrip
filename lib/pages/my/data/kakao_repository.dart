
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_kotrip/pages/my/model/address_model.dart';

class KakaoRepository {
  final dio = Dio();
  final key = Uri.decodeFull(dotenv.env['REST_API_KEY'] ?? '');
  final url = 'https://dapi.kakao.com/v2/local/search/keyword.json?query=';

  //장소검색
  Future<List<AddressModel>> getAddress(String text) async {
    try {
      final response = await dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'KakaoAK $key',
          },
        ),
        queryParameters: {
          // 'query': text,
          'query': '그린로63'
        }
      );
      if (response.statusCode == 200) {
        final results = response.data['documents'];
        List<AddressModel> addressList = [];

        if(results == null) return [];
        if(results is List){
          addressList = results.map((e)=>AddressModel.fromJson(Map<String, dynamic>.from(e))).toList();
        }

        return addressList;
      } else {
        print('kakao api의 리턴값이 올바르지 않음');
        return [];
      }
    } catch (e) {
      print('KakaoRepository 에러: $e');
      return [];
    }
  }
}


// {
//   "documents": [
//     {
//       "address_name": "전남 나주시 빛가람동 394",
//       "category_group_code": "",
//       "category_group_name": "",
//       "category_name": "부동산 > 주거시설 > 아파트",
//       "distance": "",
//       "id": "25982056",
//       "phone": "",
//       "place_name": "빛가람LH1단지아파트",
//       "place_url": "http://place.map.kakao.com/25982056",
//       "road_address_name": "전남 나주시 그린로 63",
//       "x": "126.77827733981779",
//       "y": "35.015725962522964"
//     },