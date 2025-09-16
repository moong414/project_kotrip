class PlaceModel {
  final String title;
  final String addr;
  final String mapx;
  final String mapy;

  PlaceModel({
    required this.title,
    required this.addr,
    required this.mapx,
    required this.mapy,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> map) {
    return PlaceModel(
      title: map['title'] ?? '',
      addr: map['addr1'] ?? '',
      mapx: map['mapx'] ?? '',
      mapy: map['mapy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'addr1': addr,
      'mapx': mapx,
      'mapy': mapy,
    };
  }
}
