import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/pages/place/data/place_model.dart';
import 'package:project_kotrip/pages/place/data/review_model.dart';
import 'package:project_kotrip/pages/place/data/google_review_repository.dart';

class ReviewState {
  String placeId;
  ReviewModel reviewModel;

  ReviewState({required this.placeId, required this.reviewModel});
}

class ReviewViewModel extends Notifier<ReviewState> {
  final reviewRepository = GoogleReviewRepository();

  @override
  build() {
    return ReviewState(
      placeId: '',
      reviewModel: ReviewModel(rating: 0, reviews: []),
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
}


final reviewViewModelProvider = NotifierProvider<ReviewViewModel, ReviewState>(
  () {
    return ReviewViewModel();
  },
);
