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
  // String authorUrl;
  // String language;
  // String originalLanguage;
  // String profilePhotoUrl;
  // int rating;
  // String relativeTimeDescription;
  String text;
  DateTime time;
  // bool translated;

  Review({
    required this.authorName,
    // required this.authorUrl,
    // required this.language,
    // required this.originalLanguage,
    // required this.profilePhotoUrl,
    // required this.rating,
    // required this.relativeTimeDescription,
    required this.text,
    required this.time,
    // required this.translated,
  });

  factory Review.fromJson(Map<String, dynamic> map) {
    return Review(
      authorName: map['author_name'] ?? 'Unknown',
      // authorUrl: map['author_url'],
      // language: map['language'],
      // originalLanguage: map['original_language'],
      // profilePhotoUrl: map['profile_photo_url'],
      // rating: map['rating'],
      // relativeTimeDescription: map['relative_time_description'],
      text: map['text'] ?? '',
      time: DateTime.fromMillisecondsSinceEpoch(
        (map['time'] ?? 0) * 1000,
      ).toLocal(),
      // translated: map['translated'],
    );
  }
}
