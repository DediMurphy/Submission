import 'package:flutter/material.dart';
import 'package:restaurantapp/data/model/restaurant_detail_response.dart';
import 'package:restaurantapp/data/service/local_database_service.dart';

class LocalDatabaseProvider extends ChangeNotifier {
  final LocalDatabaseService _service;

  LocalDatabaseProvider(this._service);

  String _message = "";

  String get message => _message;

  List<RestaurantDetail>? _restaurantList;

  List<RestaurantDetail>? get restaurantList => _restaurantList;

  RestaurantDetail? _restaurant;

  RestaurantDetail? get restaurant => _restaurant;

  Future<void> saveRestaurant(RestaurantDetail value) async {
    try {
      final result = await _service.insertItem(value);

      final isError = result == 0;
      if (isError) {
        _message = "Failed to save your data";
      } else {
        _message = "Your data is saved";
      }
    } catch (e) {
      _message = "Failed to save your data";
    }
    notifyListeners();
  }

  Future<void> loadAllRestaurant() async {
    try {
      _restaurantList = await _service.getAllItems();
      _restaurant = null;
      _message = "All of your data is loaded";
      notifyListeners();
    } catch (e) {
      _message = "Failed to load all your data";
      notifyListeners();
    }
  }

  Future<void> loadRestaurantById(String id) async {
    try {
      _restaurant = await _service.getItemById(id);
      _message = "Your data is loaded";
      notifyListeners();
    } catch (e) {
      _message = "Failed to load your data";
      notifyListeners();
    }
  }

  Future<void> removeRestaurantById(String id) async {
    try {
      await _service.removeItem(id);

      _message = "Your data is removed";
      notifyListeners();
    } catch (e) {
      _message = "Failed to remove your data";
      notifyListeners();
    }
  }

  bool checkItemBookmark(String id) {
    final isSameTourism = _restaurant!.id == id;
    return isSameTourism;
  }
}
