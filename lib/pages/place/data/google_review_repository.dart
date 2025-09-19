import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_kotrip/pages/place/data/place_model.dart';
import 'package:project_kotrip/pages/place/data/review_model.dart';

class GoogleReviewRepository {
  final dio = Dio();
  final key = Uri.decodeFull(dotenv.env['GOOGLE_API_KEY'] ?? '');
  final idUrl = 'https://maps.googleapis.com/maps/api/place/textsearch/json?';
  final detailUrl = 'https://maps.googleapis.com/maps/api/place/details/json?';
  String placeId = '';

  //장소 아이디검색&리뷰불러오기
  Future<ReviewResult?> fetchPlaceReviews({required PlaceModel place}) async {
    final map = '${place.mapy},${place.mapx}';

    //장소 아이디 검색하기
    try {
      final response = await dio.get(
        idUrl,
        queryParameters: {
          'query': place.title,
          'location': map,
          'radius': '50',
          'key': key,
        },
      );

      if (response.statusCode == 200) {
        placeId = response.data['results'][0]['place_id'];
      }
    } catch (e) {
      print('아이디검색에서 error발생!! $e');
      return null;
    }

    //리뷰가져오기
    try {
      final response = await dio.get(
        detailUrl,
        queryParameters: {
          'place_id': placeId,
          'fields': 'name,rating,reviews,user_ratings_total',
          'language': 'ko',
          'key': key,
        },
      );

      if (response.statusCode == 200) {
        final rating = (response.data['result']['rating'] ?? 0).toDouble();
        final rawReviews = response.data['result']['reviews'] as List?;
        final reviews = rawReviews != null
            ? rawReviews.map((e) => Review.fromJson(e)).toList()
            : <Review>[];

        return ReviewResult(
          placeId: placeId,
          reviewModel: ReviewModel(rating: rating, reviews: reviews),
        );
      }
    } catch (e) {
      print('리뷰가져오기에서 error발생!! $e');
    }

    return null;
  }
}
