import 'dart:convert';

import 'package:restaurantapp/data/model/restaurant_detail_response.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseService {
  static const String _databaseName = 'restaurant_app.db';
  static const String _tableName = 'restaurants';
  static const int _version = 1;

  Future<void> createTables(Database database) async {
    await database.execute(
      """CREATE TABLE $_tableName (
       id TEXT PRIMARY KEY,
       name TEXT NOT NULL,
       description TEXT,
       address TEXT NOT NULL,
       city TEXT NOT NULL,
       pictureId TEXT,
       rating REAL NOT NULL,
       categories TEXT NOT NULL,
       menus TEXT NOT NULL,
       customerReviews TEXT NOT NULL
     )
    """,
    );
  }

  Future<Database> _initializeDb() async {
    return openDatabase(
      _databaseName,
      version: _version,
      onCreate: (Database database, int version) async {
        await createTables(database);
      },
    );
  }

  Future<int> insertItem(RestaurantDetail restaurant) async {
    final db = await _initializeDb();

    final data = {
      "id": restaurant.id,
      "name": restaurant.name,
      "description": restaurant.description,
      "address": restaurant.address,
      "city": restaurant.city,
      "pictureId": restaurant.pictureId,
      "rating": restaurant.rating,
      "categories":
          jsonEncode(restaurant.categories.map((e) => e.toJson()).toList()),
      // Simpan sebagai JSON String
      "menus": jsonEncode(restaurant.menus.toJson()),
      // Simpan sebagai JSON String
      "customerReviews": jsonEncode(
          restaurant.customerReviews.map((e) => e.toJson()).toList()),
      // Simpan sebagai JSON String
    };

    return await db.insert(
      _tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<RestaurantDetail>> getAllItems() async {
    final db = await _initializeDb();
    final results = await db.query(_tableName);

    return results.map((result) => _mapToRestaurant(result)).toList();
  }

  Future<RestaurantDetail?> getItemById(String id) async {
    final db = await _initializeDb();
    try {
      final results = await db.query(
        _tableName,
        where: "id = ?",
        whereArgs: [id],
        limit: 1,
      );

      if (results.isNotEmpty) {
        return _mapToRestaurant(results.first);
      } else {
        print("Restaurant with ID: $id not found in database");
        return null;
      }
    } catch (e) {
      print("Database error: $e");
      return null;
    }
  }

  Future<int> removeItem(String id) async {
    final db = await _initializeDb();
    return await db.delete(_tableName, where: "id = ?", whereArgs: [id]);
  }

  RestaurantDetail _mapToRestaurant(Map<String, dynamic> result) {
    return RestaurantDetail(
      id: result["id"],
      name: result["name"],
      description: result["description"],
      address: result["address"],
      city: result["city"],
      pictureId: result["pictureId"],
      rating: (result["rating"] as num).toDouble(),
      categories: (jsonDecode(result["categories"]) as List<dynamic>)
          .map((e) => Category.fromJson(e))
          .toList(),
      menus: Menus.fromJson(jsonDecode(result["menus"])),
      customerReviews: (jsonDecode(result["customerReviews"]) as List<dynamic>)
          .map((e) => CustomerReview.fromJson(e))
          .toList(),
    );
  }
}
