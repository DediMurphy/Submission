import 'package:flutter/material.dart';
import 'package:restaurantapp/data/service/api_service.dart';
import 'package:restaurantapp/static/restaurant_list_result_state.dart';

class SearchRestaurantProvider extends ChangeNotifier {
  final ApiServices _apiServices;
  RestaurantListResultState _resultState = RestaurantListNoneState();

  RestaurantListResultState get resultState => _resultState;

  bool _isSearching = false;

  bool get isSearching => _isSearching;

  SearchRestaurantProvider(this._apiServices);

  Future<void> searchRestaurant(String query) async {
    if (query.isEmpty) {
      _isSearching = false;
      _resultState = RestaurantListNoneState();
      notifyListeners();
      return;
    }

    try {
      _isSearching = true;
      _resultState = RestaurantListLoadingState();
      notifyListeners();

      final result = await _apiServices.searchRestaurant(query);

      if (result.error || result.founded == 0) {
        _resultState = RestaurantListErrorState("No restaurants found");
      } else {
        _resultState = RestaurantListLoadedState(result.restaurants);
      }
    } catch (_) {
      _resultState = RestaurantListErrorState(
          "Tidak dapat terhubung ke server. Pastikan Anda memiliki koneksi internet.");
    } finally {
      notifyListeners();
    }

    notifyListeners();
  }
}
