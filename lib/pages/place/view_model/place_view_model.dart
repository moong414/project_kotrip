import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kotrip/pages/place/model/place_model.dart';
import 'package:project_kotrip/pages/place/data/tour_place_repository.dart';

class PlaceState {
  String areaCode;
  List<PlaceModel> tourPlaceList;
  List<PlaceModel> culturePlaceList;
  List<PlaceModel> foodPlaceList;
  List<PlaceModel> etcPlaceList;

  PlaceState({
    required this.areaCode,
    this.tourPlaceList = const [],
    this.culturePlaceList = const [],
    this.foodPlaceList = const [],
    this.etcPlaceList = const [],
  });

  List<PlaceModel> funcPlaceList(String kindPlace){
    if(kindPlace == 'tourPlaceList'){
      return tourPlaceList;
    }else if(kindPlace == 'culturePlaceList'){
      return culturePlaceList;
    }else if(kindPlace == 'foodPlaceList'){
      return foodPlaceList;
    }else{
      return etcPlaceList;
    }
  }
}

class PlaceViewModel extends Notifier<PlaceState> {
  final placeRepository = TourPlaceRepository();

  @override
  PlaceState build() {
    return PlaceState(areaCode: '');
  }

  //장소가져오기
  Future<void> loadPlaces({required String areaCode}) async {
    final tourData = await placeRepository.fetchPlaceList(areaCode: areaCode, contentTypeId: '12'); //관광지
    final culData = await placeRepository.fetchPlaceList(areaCode: areaCode, contentTypeId: '14'); //문화시설
    final foodData = await placeRepository.fetchPlaceList(areaCode: areaCode, contentTypeId: '39'); //음식점
    final etcData = await placeRepository.fetchPlaceList(areaCode: areaCode, contentTypeId: '38'); //쇼핑

    // 이미지 없는 항목 제거
    // final tourList = tourData.where((place) => place.firstimage.isNotEmpty).toList();
    // final culList = culData.where((place) => place.firstimage.isNotEmpty).toList();
    // final foodList = foodData.where((place) => place.firstimage.isNotEmpty).toList();
    // final etcList = etcData.where((place) => place.firstimage.isNotEmpty).toList();

    state = PlaceState(areaCode: areaCode, tourPlaceList: tourData, culturePlaceList: culData, foodPlaceList: foodData, etcPlaceList: etcData);
  }
  
}

final placeViewModelProvider = NotifierProvider<PlaceViewModel, PlaceState>(() {
  return PlaceViewModel();
});
