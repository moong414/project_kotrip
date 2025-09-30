import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/pages/place/model/place_model.dart';
import 'package:project_kotrip/pages/place/model/review_model.dart';
import 'package:project_kotrip/pages/place/data/google_review_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class ReviewState {
  String placeId;
  GoogleReviewModel reviewModel;

  ReviewState({required this.placeId, required this.reviewModel});
}

class ReviewViewModel extends Notifier<ReviewState> {
  final reviewRepository = GoogleReviewRepository();

  @override
  build() {
    return ReviewState(
      placeId: '',
      reviewModel: GoogleReviewModel(rating: 0, reviews: []),
    );
  }

  //리뷰, 평점 불러오기
  Future<void> loadReview({required PlaceModel place}) async {
    final reviewData = await reviewRepository.fetchPlaceReviews(place: place);
    if (reviewData != null) {
      state = ReviewState(
        placeId: reviewData.placeId,
        reviewModel: reviewData.reviewModel,
      );
    }
  }

  //장소 구글맵으로 열기
  Future<void> openGoogleMap(String placeId, String placeName) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(placeName)}&query_place_id=$placeId';
    final uri = Uri.parse(url);
    if (await launchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('구글맵으로 열기 실패!! $url');
    }
  }
}

final reviewViewModelProvider = NotifierProvider<ReviewViewModel, ReviewState>(
  () {
    return ReviewViewModel();
  },
);
