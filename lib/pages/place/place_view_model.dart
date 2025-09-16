import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/data/model/place_model.dart';
import 'package:project_kotrip/data/repository/place_repository.dart';

class PlaceState {
  String areaCode;
  List<PlaceModel> tourPlaceList;
  List<PlaceModel> culturePlaceList;
  List<PlaceModel> foodPlaceList;

  PlaceState({
    required this.areaCode,
    this.tourPlaceList = const [],
    this.culturePlaceList = const [],
    this.foodPlaceList = const [],
  });

  List<PlaceModel> funcPlaceList(String kindPlace){
    if(kindPlace == 'tourPlaceList'){
      return tourPlaceList;
    }else if(kindPlace == 'culturePlaceList'){
      return culturePlaceList;
    }else{
      return foodPlaceList;
    }
  }
}

class PlaceViewModel extends Notifier<PlaceState> {
  @override
  PlaceState build() {
    return PlaceState(areaCode: '');
  }

  Future<void> loadPlaces({required String areaCode}) async {
    final placeRepository = PlaceRepository();
    final tourData = await placeRepository.fetchPlaceList(areaCode: areaCode, contentTypeId: '12');
    final culData = await placeRepository.fetchPlaceList(areaCode: areaCode, contentTypeId: '14');
    final foodData = await placeRepository.fetchPlaceList(areaCode: areaCode, contentTypeId: '39');

    // 이미지 없는 항목 제거
    final tourList = tourData.where((place) => place.firstimage.isNotEmpty).toList();
    final culList = culData.where((place) => place.firstimage.isNotEmpty).toList();
    final foodList = foodData.where((place) => place.firstimage.isNotEmpty).toList();

    state = PlaceState(areaCode: areaCode, tourPlaceList: tourList, culturePlaceList: culList, foodPlaceList: foodList);
  }
}

final placeViewModelProvider = NotifierProvider<PlaceViewModel, PlaceState>(() {
  return PlaceViewModel();
});
