//구글 리뷰 결과(장소Id, 리뷰 리스트)
class GoogleReviewResult{
  String placeId;
  GoogleReviewModel reviewModel;
  GoogleReviewResult({required this.placeId, required this.reviewModel});
}
//구글 리뷰(평점, 리뷰리스트)
class GoogleReviewModel {
  double rating;
  List<Review> reviews;
  GoogleReviewModel({required this.rating, required this.reviews});

  factory GoogleReviewModel.fromJson(Map<String, dynamic> json) {
    return GoogleReviewModel(
      rating: json['rating'].toDouble(),
      reviews: (json['reviews'] as List).map((e) {
        return Review.fromJson(e);
      }).toList(),
    );
  }
}
//리뷰모델(작성자, 리뷰내용, 시간)
class Review {
  String authorName;
  String text;
  DateTime time;

  Review({
    required this.authorName,
    required this.text,
    required this.time,
  });

  factory Review.fromJson(Map<String, dynamic> map) {
    return Review(
      authorName: map['author_name'] ?? 'Unknown',
      text: map['text'] ?? '',
      time: DateTime.fromMillisecondsSinceEpoch(
        (map['time'] ?? 0) * 1000,
      ).toLocal(),
    );
  }
}
