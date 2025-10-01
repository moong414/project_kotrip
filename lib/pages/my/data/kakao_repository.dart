
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_kotrip/pages/my/model/address_model.dart';

class KakaoRepository {
  final dio = Dio();
  final key = Uri.decodeFull(dotenv.env['REST_API_KEY'] ?? '');
  final url = 'https://dapi.kakao.com/v2/local/search/keyword.json?';

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
          'query': text,
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
