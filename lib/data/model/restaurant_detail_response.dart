import 'dart:convert';

class RestaurantDetailResponse {
  final bool error;
  final String message;
  final RestaurantDetail restaurant;

  RestaurantDetailResponse({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory RestaurantDetailResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailResponse(
        error: json["error"],
        message: json["message"],
        restaurant: RestaurantDetail.fromJson(json["restaurant"]));
  }
}

class RestaurantDetail {
  final String id;
  final String name;
  final String? description;
  final String? pictureId;
  final String? city;
  final String address;
  final double rating;
  final List<Category> categories;
  final Menus menus;
  final List<CustomerReview> customerReviews;

  RestaurantDetail({
    required this.id,
    required this.name,
    this.description,
    this.pictureId,
    this.city,
    required this.address,
    required this.rating,
    required this.categories,
    required this.menus,
    required this.customerReviews,
  });

  String get imageUrl =>
      "https://restaurant-api.dicoding.dev/images/small/$pictureId";

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    return RestaurantDetail(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      city: json["city"] ?? "Unknown City",
      address: json["address"] ?? "No address available",
      pictureId: json["pictureId"] ?? "",
      rating: (json["rating"] as num?)?.toDouble() ?? 0.0,
      categories: (json["categories"] as List<dynamic>?)
              ?.map((e) => Category.fromJson(e))
              .toList() ??
          [],
      menus: json["menus"] != null
          ? Menus.fromJson(json["menus"])
          : Menus(foods: [], drinks: []),
      customerReviews: (json["customerReviews"] as List<dynamic>?)
              ?.map((e) => CustomerReview.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "description": description,
      "address": address,
      "pictureId": pictureId,
      "city": city,
      "rating": rating,
      "categories": jsonEncode(categories.map((e) => e.toJson()).toList()),
      "menus": jsonEncode(menus.toJson()),
      "customerReviews":
          jsonEncode(customerReviews.map((e) => e.toJson()).toList()),
    };
  }

  factory RestaurantDetail.fromDatabaseJson(Map<String, dynamic> json) {
    return RestaurantDetail(
      id: json["id"] ?? "",
      name: json["name"] ?? "Unknown",
      description: json["description"] ?? "No description available",
      city: json["city"] ?? "Unknown City",
      address: json["address"] ?? "No address available",
      pictureId: json["pictureId"] ?? "",
      rating: (json["rating"] as num?)?.toDouble() ?? 0.0,
      categories: (json["categories"] != null)
          ? (jsonDecode(json["categories"]) as List)
              .map((e) => Category.fromJson(e))
              .toList()
          : [],
      menus: (json["menus"] != null)
          ? Menus.fromJson(jsonDecode(json["menus"]))
          : Menus(foods: [], drinks: []),
      customerReviews: (json["customerReviews"] != null)
          ? (jsonDecode(json["customerReviews"]) as List)
              .map((e) => CustomerReview.fromJson(e))
              .toList()
          : [],
    );
  }
}

class Category {
  final String name;

  Category({required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(name: json["name"] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
    };
  }
}

class CustomerReview {
  final String name;
  final String review;
  final String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    return CustomerReview(
      name: json["name"] ?? "",
      review: json["review"] ?? "",
      date: json["date"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "review": review,
      "date": date,
    };
  }
}

class Menus {
  final List<Food> foods;
  final List<Drink> drinks;

  Menus({required this.foods, required this.drinks});

  factory Menus.fromJson(Map<String, dynamic> json) {
    return Menus(
      foods: (json["foods"] as List<dynamic>?)
              ?.map((e) => Food.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      drinks: (json["drinks"] as List<dynamic>?)
              ?.map((e) => Drink.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "foods": foods.map((e) => e.toJson()).toList(),
      "drinks": drinks.map((e) => e.toJson()).toList(),
    };
  }
}

class Drink {
  final String name;

  Drink({required this.name});

  factory Drink.fromJson(Map<String, dynamic> json) {
    return Drink(name: json["name"] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
    };
  }
}

class Food {
  final String name;

  Food({required this.name});

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(name: json["name"] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
    };
  }
}
