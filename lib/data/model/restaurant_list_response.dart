
import 'package:restaurantapp/data/model/restaurant.dart';

class RestaurantListResponse {
  final bool error;
  final String message;
  final int count;
  final List<Restaurant> restaurants;

  RestaurantListResponse({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  // langkah 3
  // Tahapan formatting respons Web API untuk endpoint pertama sudah selesai.
  factory RestaurantListResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantListResponse(
      error: json["error"],
      message: json["message"],
      count: json["count"],
      restaurants: json["restaurants"] != null
          ? List<Restaurant>.from(json["restaurants"]!.map((x) => Restaurant.fromJson(x)))
          : <Restaurant>[],
    );
  }

}