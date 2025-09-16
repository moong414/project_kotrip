import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/data/model/place_model.dart';
import 'package:project_kotrip/data/repository/place_repository.dart';

class PlaceState {
  String areaCode;
  List<PlaceModel> places;
  PlaceState({required this.areaCode, required this.places});
}

class PlaceViewModel extends Notifier<PlaceState> {
  @override
  PlaceState build() {
    return PlaceState(areaCode: '', places: []);
  }

  Future<void> loadPlaces({
    required String areaCode,
    String? contentTypeId,
  }) async {
    final placeRepository = PlaceRepository();
    var placeList = await placeRepository.fetchPlaceList(areaCode);

    // 이미지 없는 항목 제거
    placeList = placeList
        .where((place) => place.firstimage.isNotEmpty)
        .toList();

    // contentTypeId 필터링
    if (contentTypeId != null) {
      placeList = placeList
          .where((place) => place.contentTypeId.toString() == contentTypeId)
          .toList();
    }

    state = PlaceState(areaCode: areaCode, places: placeList);
  }
}

final placeViewModelProvider = NotifierProvider<PlaceViewModel, PlaceState>(() {
  return PlaceViewModel();
});
