import 'package:flutter/material.dart';
import 'package:restaurantapp/data/service/api_service.dart';

class ReviewProvider extends ChangeNotifier {
  final ApiServices _apiServices;
  List<Map<String, String>> _reviews = [];

  List<Map<String, String>> get reviews => _reviews;

  ReviewProvider(this._apiServices);

  Future<void> fetchReviews(String restaurantId) async {
    try {
      final result = await _apiServices.getRestaurantDetail(restaurantId);
      _reviews = result.restaurant.customerReviews
          .map((review) => {
                "name": review.name,
                "review": review.review,
                "date": review.date,
              })
          .toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching reviews: $e");
    }
  }

  Future<void> submitReview(
      String restaurantId, String name, String review) async {
    try {
      final response =
          await _apiServices.submitReview(restaurantId, name, review);
      if (!response.error) {
        _reviews = response.customerReviews
            .map((review) => {
                  "name": review.name,
                  "review": review.review,
                  "date": review.date,
                })
            .toList();
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error submitting review: $e");
    }
  }
}
