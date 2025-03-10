class Restaurant {
  final String id;
  final String name;
  final String? description;
  final String? pictureId;
  final String? city;
  final double rating;

  Restaurant({
    required this.id,
    required this.name,
    this.description,
    this.pictureId,
    this.city,
    required this.rating,
  });

  String get imageUrl =>
      "https://restaurant-api.dicoding.dev/images/small/$pictureId";

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      city: json["city"],
      pictureId: json["pictureId"],
      rating: (json["rating"] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "description": description,
      "pictureId": pictureId,
      "city": city,
      "rating": rating,
    };
  }

  factory Restaurant.fromDatabaseJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      city: json["city"],      
      pictureId: json["pictureId"],
      rating: (json["rating"] as num?)?.toDouble() ?? 0.0,
    );
  }
}
