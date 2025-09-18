class ReviewResult{
  String placeId;
  ReviewModel reviewModel;

  ReviewResult({required this.placeId, required this.reviewModel});
}


class ReviewModel {
  double rating;
  List<Review> reviews;

  ReviewModel({required this.rating, required this.reviews});

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      rating: json['rating'].toDouble(),
      reviews: (json['reviews'] as List).map((e) {
        return Review.fromJson(e);
      }).toList(),
    );
  }
}

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
