import 'package:flutter/cupertino.dart';
import 'package:restaurantapp/data/model/restaurant.dart';

class FavoriteListProvider extends ChangeNotifier {
  final List<Restaurant> _favoriteList = [];

  List<Restaurant> get FavoriteList => _favoriteList;

  void addFavorites(Restaurant value) {
    _favoriteList.add(value);
    notifyListeners();
  }

  void removeFavorites(Restaurant value) {
    _favoriteList.removeWhere((element) => element.id == value.id);
    notifyListeners();
  }

  bool checkItemFavorite(Restaurant value) {
    final restaurantInList =
        _favoriteList.where((element) => element.id == value.id);
    return restaurantInList.isNotEmpty;
  }
}
