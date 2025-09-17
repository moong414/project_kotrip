import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/data/model/place_model.dart';
import 'package:project_kotrip/data/model/review_model.dart';
import 'package:project_kotrip/data/repository/google_review_repository.dart';

class ReviewState{
  ReviewModel reviewModel;

  ReviewState({required this.reviewModel});
}

class ReviewViewModel extends Notifier<ReviewState>{
  final reviewRepository = GoogleReviewRepository();

  @override
  build() {
    return ReviewState(reviewModel: ReviewModel(rating: 0, reviews: []));
  }

  Future<void> loadReview({required PlaceModel place}) async{
    final reviewData = await reviewRepository.fetchPlaceReviews(place: place);

    if(reviewData != null){
      state = ReviewState(reviewModel: reviewData);
    }
  }
}

final reviewViewModelProvider = NotifierProvider<ReviewViewModel, ReviewState>(() {
  return ReviewViewModel();
});
