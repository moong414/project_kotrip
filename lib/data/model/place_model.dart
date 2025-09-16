class PlaceModel {
  final String title;
  final String addr;
  final String mapx;
  final String mapy;
  final String firstimage;
  final String contentTypeId;

  PlaceModel({
    required this.title,
    required this.addr,
    required this.mapx,
    required this.mapy,
    required this.firstimage,
    required this.contentTypeId
  });

  factory PlaceModel.fromJson(Map<String, dynamic> map) {
    return PlaceModel(
      title: map['title']?.toString() ?? '',
      addr: map['addr1']?.toString() ?? '',
      mapx: map['mapx']?.toString() ?? '',
      mapy: map['mapy']?.toString() ?? '',
      firstimage: map['firstimage']?.toString() ?? '',
      contentTypeId: map['contentTypeId']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'addr1': addr,
      'mapx': mapx,
      'mapy': mapy,
      'firstimage': firstimage,
      'contentTypeId': contentTypeId,
    };
  }
}