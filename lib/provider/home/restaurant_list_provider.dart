import 'package:flutter/material.dart';
import 'package:restaurantapp/data/service/api_service.dart';
import 'package:restaurantapp/static/restaurant_list_result_state.dart';

class RestaurantListProvider extends ChangeNotifier {
  // OBJECT
  final ApiServices _apiServices;

  RestaurantListProvider(
    this._apiServices,
  );

  RestaurantListResultState _resultState = RestaurantListNoneState();

  RestaurantListResultState get resultState => _resultState;

  Future<void> fetchRestaurantList() async {
    try {
      _resultState = RestaurantListLoadingState();
      notifyListeners();

      final result = await _apiServices.getRestaurantList();

      if (result.error) {
        _resultState = RestaurantListErrorState(result.message);
      } else {
        _resultState = RestaurantListLoadedState(result.restaurants);
      }
    } catch (_) {
      _resultState = RestaurantListErrorState(
          "Tidak dapat terhubung ke server. Pastikan Anda memiliki koneksi internet.");
    } finally {
      notifyListeners();
    }
  }
}
