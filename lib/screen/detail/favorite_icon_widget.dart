import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantapp/data/model/restaurant_detail_response.dart';
import 'package:restaurantapp/provider/detail/favorite_icon_provider.dart';
import 'package:restaurantapp/provider/local/local_database_provider.dart';

class FavoriteIconWidget extends StatefulWidget {
  final RestaurantDetail restaurant;

  const FavoriteIconWidget({
    super.key,
    required this.restaurant,
  });

  @override
  State<FavoriteIconWidget> createState() => _FavoriteIconWidgetState();
}

class _FavoriteIconWidgetState extends State<FavoriteIconWidget> {
  @override
  void initState() {
    super.initState();
    final localDatabaseProvider = context.read<LocalDatabaseProvider>();
    final bookmarkIconProvider = context.read<FavoriteIconProvider>();

    Future.microtask(() async {
      await localDatabaseProvider.loadRestaurantById(widget.restaurant.id);
      final value = localDatabaseProvider.restaurant == null
          ? false
          : localDatabaseProvider.restaurant!.id == widget.restaurant.id;
      bookmarkIconProvider.isFavoriteed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final localDatabaseProvider = context.read<LocalDatabaseProvider>();
        final bookmarkIconProvider = context.read<FavoriteIconProvider>();
        final isFavoriteed = bookmarkIconProvider.isFavoriteed;

        if (isFavoriteed) {
          await localDatabaseProvider
              .removeRestaurantById(widget.restaurant.id);
        } else {
          await localDatabaseProvider.saveRestaurant(widget.restaurant);
        }
        bookmarkIconProvider.isFavoriteed = !isFavoriteed;
        localDatabaseProvider.loadAllRestaurant();
      },
      icon: Icon(
        context.watch<FavoriteIconProvider>().isFavoriteed
            ? Icons.bookmark
            : Icons.bookmark_outline,
      ),
    );
  }
}
