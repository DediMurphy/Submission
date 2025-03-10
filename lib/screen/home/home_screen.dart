import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantapp/provider/home/restaurant_list_provider.dart';
import 'package:restaurantapp/provider/home/search_restaurant_provider.dart';
import 'package:restaurantapp/screen/home/restaurant_card_widget.dart';
import 'package:restaurantapp/screen/setting/setting_screen.dart';
import 'package:restaurantapp/static/navigation_route.dart';

import '../../static/restaurant_list_result_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<RestaurantListProvider>(context, listen: false)
          .fetchRestaurantList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurant"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()));
            },
            icon: const Icon(Icons.settings),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search Restaurant",
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (query) {
                final searchProvider = Provider.of<SearchRestaurantProvider>(
                    context,
                    listen: false);
                searchProvider.searchRestaurant(query);
              },
            ),
          ),
        ),
      ),
      body: Consumer<SearchRestaurantProvider>(
        builder: (context, searchProvider, child) {
          if (searchProvider.isSearching) {
            return _buildSearchResults(searchProvider);
          }

          return Consumer<RestaurantListProvider>(
            builder: (context, provider, child) {
              return switch (provider.resultState) {
                RestaurantListLoadingState() =>
                  const Center(child: CircularProgressIndicator()),
                RestaurantListLoadedState(data: var restaurantList) =>
                  _buildRestaurantList(restaurantList),
                RestaurantListErrorState(message: var message) =>
                  Center(child: Text(message)),
                _ => const SizedBox(),
              };
            },
          );
        },
      ),
    );
  }

  Widget _buildSearchResults(SearchRestaurantProvider searchProvider) {
    final state = searchProvider.resultState;

    return switch (state) {
      RestaurantListLoadingState() =>
        const Center(child: CircularProgressIndicator()),
      RestaurantListLoadedState(data: var searchResults) =>
        _buildRestaurantList(searchResults),
      RestaurantListErrorState(message: var message) =>
        Center(child: Text(message)),
      _ => const Center(child: Text("Type to search restaurants")),
    };
  }

  Widget _buildRestaurantList(List restaurantList) {
    return restaurantList.isEmpty
        ? const Center(child: Text("No restaurants found"))
        : ListView.builder(
            itemCount: restaurantList.length,
            itemBuilder: (context, index) {
              final restaurant = restaurantList[index];
              return RestaurantCard(
                restaurant: restaurant,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    NavigationRoute.detailRoute.name,
                    arguments: restaurant.id,
                  );
                },
              );
            },
          );
  }
}
