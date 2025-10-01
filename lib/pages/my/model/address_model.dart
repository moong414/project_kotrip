class AddressModel {
  String addressName;
  String placeName;
  String mapX;
  String mapY;

  AddressModel({
    required this.addressName,
    required this.placeName,
    required this.mapX,
    required this.mapY,
  });

  factory AddressModel.fromJson(Map<String, dynamic> map) {
    final road = map['road_address'];
    final addr = map['address'];

    return AddressModel(
      addressName: road?['address_name'] ?? addr?['address_name'] ?? '',
      placeName: map['place_name'] ?? '',
      mapX: map['x'] ?? '',
      mapY: map['y'] ?? '',
    );
  }

  Map<String, dynamic> toJson(){
    return { 
      'address_name': addressName,
      'place_name': placeName, 
      'x': mapX,
      'y': mapY,
    };
  }
}
