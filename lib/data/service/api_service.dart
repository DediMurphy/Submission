import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurantapp/data/model/review_restaurant_model.dart';
import 'package:restaurantapp/data/model/search_restaurant_model.dart';

import '../model/restaurant_detail_response.dart';
import '../model/restaurant_list_response.dart';

class ApiServices {
  static const String _baseUrl = "https://restaurant-api.dicoding.dev";

  Future<RestaurantListResponse> getRestaurantList() async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/list"));

      if (response.statusCode == 200) {
        return RestaurantListResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Gagal memuat daftar restoran. Silakan coba lagi nanti.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan. Periksa koneksi internet Anda.');
    }
  }

  Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/detail/$id"));

      if (response.statusCode == 200) {
        return RestaurantDetailResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Gagal Memuat halaman detail');
      }
    } catch (e) {
      throw Exception('Terjadi Kesalahan. Periksa Internet anda');
    }
  }

  Future<RestaurantSearchResponse> searchRestaurant(String query) async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/search?q=$query"));

      if (response.statusCode == 200) {
        return RestaurantSearchResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('search tidak ditemukan');
      }
    } catch (e) {
      throw Exception('Terjadi Kesalahan. Periksa Internet anda');
    }
  }

  Future<ReviewResponse> submitReview(
      String id, String name, String review) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/review"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": id, "name": name, "review": review}),
    );

    return ReviewResponse.fromJson(json.decode(response.body));
  }
}
