
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_kotrip/pages/my/model/address_model.dart';

class KakaoRepository {
  final dio = Dio();
  final key = Uri.decodeFull(dotenv.env['REST_API_KEY'] ?? '');
  final searchUrl = 'https://dapi.kakao.com/v2/local/search/keyword.json?';
  final geoUrl = 'https://dapi.kakao.com/v2/local/geo/coord2address.json?';

  //장소검색
  Future<List<AddressModel>> getAddress(String text) async {
    try {
      final response = await dio.post(
        searchUrl,
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
        debugPrint('kakao api의 리턴값이 올바르지 않음');
        return [];
      }
    } catch (e) {
      debugPrint('KakaoRepository 에러: $e');
      return [];
    }
  }

  //GPS연동 좌표 검색
  Future<AddressModel?> getAddressFromGps(String x, String y) async {
    debugPrint('REST API KEY: $key');
    debugPrint('GPS 요청 x=$x, y=$y');
    try {
      final response = await dio.get(
        geoUrl,
        options: Options(
          headers: {
            'Authorization': 'KakaoAK $key',
          },
        ),
        queryParameters: {
          'x': x,
          'y': y,
        }
      );

      debugPrint('응답 상태: ${response.statusCode}');
      debugPrint('응답 데이터: ${response.data}');

      if (response.statusCode == 200) {
        final results = response.data['documents'];

        if (results == null || results.isEmpty) return null;

        final firstDoc = results[0];

        // road_address가 있으면 우선 사용, 없으면 address 사용
        final addressData = firstDoc['road_address'] ?? firstDoc['address'];

        if (addressData == null) return null;

        final firstResult = AddressModel.fromJson(
          Map<String, dynamic>.from(addressData),
        );

        return firstResult;
      } else {
        debugPrint('kakao api의 리턴값이 올바르지 않음');
        return null;
      }
    } catch (e) {
      debugPrint('KakaoRepository 에러: $e');
      return null;
    }
  }

}
