import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_kotrip/data/model/place_model.dart';
import 'package:project_kotrip/data/model/review_model.dart';

class GoogleReviewRepository {
  final dio = Dio();
  final key = Uri.decodeFull(dotenv.env['GOOGLE_API_KEY'] ?? '');
  final idUrl = 'https://maps.googleapis.com/maps/api/place/textsearch/json?';
  final detailUrl = 'https://maps.googleapis.com/maps/api/place/details/json?';

  Future<ReviewModel?> fetchPlaceReviews({required PlaceModel place}) async {
    final map = '${place.mapy},${place.mapx}';
    String placeId = '';

    //장소 아이디 검색하기
    try {
      final response = await dio.get(
        idUrl,
        queryParameters: {
          'query' : place.title,
          'location': map, 
          'radius': '50', 
          'key': key},
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

        return ReviewModel(rating: rating, reviews: reviews);
      }
    } catch (e) {
      print('리뷰가져오기에서 error발생!! $e');
    }

    return null;
  }
}

// {
//   "html_attributions": [],
//   "results": [
//     {
//       "geometry": {
//         "location": {
//           "lat": 37.56521290000001,
//           "lng": 126.9773517
//         },
//         "viewport": {
//           "northeast": {
//             "lat": 37.7014549458459,
//             "lng": 127.18379492437
//           },
//           "southwest": {
//             "lat": 37.42829725537645,
//             "lng": 126.7644837308701
//           }
//         }
//       },
//       "icon": "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/geocode-71.png",
//       "icon_background_color": "#7B9EB0",
//       "icon_mask_base_uri": "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",
//       "name": "Seoul",
//       "photos": [
//         {
//           "height": 1350,
//           "html_attributions": [
//             "<a href=\"https://maps.google.com/maps/contrib/113822669839196364739\">Kashif Abbasi</a>"
//           ],
//           "photo_reference": "AciIO2fHANoI20wTYBIwbAOqyDB4c-LNIZqx-CV-thiruslFJPjQpY-N5fg7YJWt64DWekeN-HTj1GacyAniKoBqg7HvXVO6ej9jCSjD2t3kx4ZcPL7LyF2ng_wLrLFIXlQnDlHP_N1RgXso0U_y16jXIJGOGJZ9C0ltB1FM1seFGiENxLp0-ixCKEgJsaP5xuQsoOg2Ap-NU71lnWh7vn-eemtW0psygM7Z79ZE4CP0KniVMJN2swyq699_4Y6fPA8H5NiSe2GgnoCoHFabETN2XeVy2mMEAVqWRQ0pOzj8U0sRWDybIhNoWvgmhR_AVJQKu6afhWCcPNJoYerVce_kyRlDxyAz28VSr49W7Dad9SPFFX3HDAtHt0Z9iWnAh7TgQJybGWT5zgB2cWW880gOdvzJV8o4PUy7D-Cc97mN_fraH4kVyjDo5tOqw832RnsuMeV2sRQrFQMZntVtIJwEYRzJKIZia8vAadT54L11laaSqqTg_XEZ9b_XwVFecTqJB2htbnMCqFGBaSbbj0T-Tx5r8UrRiWJkyTXJBQapXi4Y5DlsUdL0iHbKatA6Gt1g6sWJHS1ZA5RUHhlOuDjaVU0VZeT1GRBrQ2Epmf4VOJaG3DXWjhQcRxjQBW6RfFF8YpxqYH2-",
//           "width": 1080
//         }
//       ],
//       "place_id": "ChIJzWXFYYuifDUR64Pq5LTtioU",
//       "reference": "ChIJzWXFYYuifDUR64Pq5LTtioU",
//       "scope": "GOOGLE",
//       "types": [
//         "locality",
//         "political"
//       ],
//       "vicinity": "Seoul"
//     },
//     {
//       "geometry": {
//         "location": {
//           "lat": 37.5819561,
//           "lng": 127.054846
//         },
//         "viewport": {
//           "northeast": {
//             "lat": 37.60761904566385,
//             "lng": 127.0782021231829
//           },
//           "southwest": {
//             "lat": 37.55995939903616,
//             "lng": 127.0231379376804
//           }
//         }
//       },
//       "icon": "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/geocode-71.png",
//       "icon_background_color": "#7B9EB0",
//       "icon_mask_base_uri": "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",
//       "name": "Dongdaemun District",
//       "photos": [
//         {
//           "height": 3024,
//           "html_attributions": [
//             "<a href=\"https://maps.google.com/maps/contrib/106235844689005580623\">배상훈</a>"
//           ],
//           "photo_reference": "AciIO2dbDlToj5q2KpP-RXXINaouKVYNu2F-kc-r4jlhdGUdcKKGdF8QviXzQxXvEmQRObplNmVRgMdPH3lKFvN41INbOgnt45BZIxFlG6nH0Ix8oa0oJt84IjsVfPffErBKwZ040P_T5ctyEzVgw3Xg4XEcmtA4515wpBwHcy5H1aZwLL_5jNU21Zx8PgU5ss8kOrAaBWDKst0zncc7Y6gk5Jrh2L0l4crRei-Epcd-YVekCvcpxRt72qgyRBzd2szdm9AlZoTi5lmIfJNtNdUsZrPI8ODVI60GoxBriiZIjAsJxmqjsYcucXqKVyOicjSchOVninvrwjhTEasnYeMYgZRFXs3-HeZdinrkIFCplW-4z0XsakOJ4q0owPo3691mbUJrKjokoIBpaqAIQLailtKQVMlhUwwBFB3J0-xdlxRZyw20xnGZa-JOEX16dLWoZhXMPnGeWuSRlVEvjTiPf4MiTIit9UMDPy5coeUlHpzAoOg3K5j_fMiYG3iMtQUJifXeCEUGDyjR45zQu7jfT-IzoiFDT4jwDAO_VTfT9pmpI-mOfB9eKiLofxN065fhXLil-ziN3kc5GNHjaLsLFKqrs7wyFWItgZ99onTWTSwBpr1thSJbn5yfETQ6hr_tS8bnn_7F",
//           "width": 4032
//         }
//       ],
//       "place_id": "ChIJwY4p1Fy7fDURJCttt7vIQOA",
//       "reference": "ChIJwY4p1Fy7fDURJCttt7vIQOA",
//       "scope": "GOOGLE",
//       "types": [
//         "sublocality_level_1",
//         "sublocality",
//         "political"
//       ],
//       "vicinity": "Dongdaemun District"
//     }
//   ],
//   "status": "OK"
// }


// {
//   "html_attributions": [],
//   "result": {
//     "name": "N Seoul Tower",
//     "rating": 4.5,
//     "reviews": [
//       {
//         "author_name": "Olivia",
//         "author_url": "https://www.google.com/maps/contrib/109806443526114344798/reviews",
//         "language": "en",
//         "original_language": "en",
//         "profile_photo_url": "https://lh3.googleusercontent.com/a-/ALV-UjXj3zfRjI8Zf8WrmSIxQ297igW9GQI4kd1uiKmHl61vVo1-T7Hv=s128-c0x00000000-cc-rp-mo-ba2",
//         "rating": 5,
//         "relative_time_description": "2 weeks ago",
//         "text": "Went in the Fall in 2023 and the Summer 2025 and both seasons were beautiful! It's so beautiful and a wonderful view of the city. There are locks available everywhere so if you don't see one you like at the cable car station look at the little shops and vending machines around or even bring your own! A very romantic spot to \"lock in\" your love ❤️",
//         "time": 1756443877,
//         "translated": false
//       },
//       {
//         "author_name": "Tanmaya Sahoo",
//         "author_url": "https://www.google.com/maps/contrib/113737679273734511786/reviews",
//         "language": "en",
//         "original_language": "en",
//         "profile_photo_url": "https://lh3.googleusercontent.com/a-/ALV-UjWr4NtOieSqORupbM1Om50CW71-PEbzQwXFiGNGBFzBFdHX8IyP=s128-c0x00000000-cc-rp-mo-ba4",
//         "rating": 5,
//         "relative_time_description": "3 weeks ago",
//         "text": "A vibrant and awesome view of seoul\n\nWith amazing clouds in the top\nTry to go there in the evening, as u can see the proper scenery\n\nFor foreigners don't forget to go through klook app for checking tickets price\n\nAnd if u r love birds find lock and go for it.\n\nTry catch some samurai shows if possible tbh it's totally worth it for eyes🤌🏻",
//         "time": 1756082867,
//         "translated": false
//       },
//       {
//         "author_name": "Salman Abir",
//         "author_url": "https://www.google.com/maps/contrib/108467432486488527213/reviews",
//         "language": "en",
//         "original_language": "en",
//         "profile_photo_url": "https://lh3.googleusercontent.com/a-/ALV-UjWVpkcbQuniDQD-hqfJHeVhhHu7QvrOSgba9S-lWBnd-UWRjOIufQ=s128-c0x00000000-cc-rp-mo-ba4",
//         "rating": 4,
//         "relative_time_description": "a month ago",
//         "text": "This is a really nice place with a great ambiance. It does feel a bit on the expensive side, but the overall experience makes it worth it. You can definitely spend some quality time here, whether you're with friends, family, or even on your own. The atmosphere is relaxing, and the service is quite good too. I'd recommend giving it a try if you're looking for a pleasant outing.",
//         "time": 1753519173,
//         "translated": false
//       },
//       {
//         "author_name": "Rashan Fray",
//         "author_url": "https://www.google.com/maps/contrib/102870055658548948550/reviews",
//         "language": "en",
//         "original_language": "en",
//         "profile_photo_url": "https://lh3.googleusercontent.com/a-/ALV-UjUywqpbAP__eLhOryorVNwSRdkxtjyITfHOK1Um1OzQXVbao009XA=s128-c0x00000000-cc-rp-mo-ba3",
//         "rating": 5,
//         "relative_time_description": "a month ago",
//         "text": "N Seoul Tower is one of those places you just have to visit when you’re in Seoul. It’s an iconic landmark for a reason. The views from the top are absolutely incredible — a full 360° panorama of the city that’s breathtaking both during the day and at night.\n\nGetting up there is part of the fun, especially if you take the Namsan Cable Car (though that part could use a refresh). Once you’re at the top, the area around the tower has a nice vibe — lively but not overwhelming. There are cafes, gift shops, and even a place to grab food or sit and chill while taking in the view.\n\nThe observation deck is clean and well-maintained, and the experience feels organized from start to finish. You’ll also find the famous love locks area just outside, which makes for a fun stop whether you’re traveling solo or with someone.\n\nEven if you’re only in Seoul for a short time, make sure this is on your list. It’s touristy, sure — but totally worth it.",
//         "time": 1753198724,
//         "translated": false
//       },
//       {
//         "author_name": "Cinthia Benites",
//         "author_url": "https://www.google.com/maps/contrib/104653131625727581321/reviews",
//         "language": "en",
//         "original_language": "en",
//         "profile_photo_url": "https://lh3.googleusercontent.com/a-/ALV-UjX74ciuKepf75fDYEKqJI3vn0fKJfI_-k7JX7Q0B7hwcGEGNDmL=s128-c0x00000000-cc-rp-mo-ba2",
//         "rating": 5,
//         "relative_time_description": "a month ago",
//         "text": "I went in the morning and the view was spectacular. We went up the tower and couldn’t stop taking photos. You should go on a clear day so you can see everything better. The way down is also beautiful; however, if you get tired easily, you should wear comfortable shoes. I recommend taking the cable car up and walking down so it’s not too tiring.",
//         "time": 1755192232,
//         "translated": false
//       }
//     ],
//     "user_ratings_total": 64518
//   },
//   "status": "OK"
// }