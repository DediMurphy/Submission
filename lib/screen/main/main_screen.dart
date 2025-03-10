import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantapp/provider/index_nav_provider.dart';
import 'package:restaurantapp/screen/favorite/favorite_screen.dart';
import 'package:restaurantapp/screen/home/home_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<IndexNavProvider>(
        builder: (context, value, child) {
          return switch (value.indexBottomNavBar) {
            0 => const HomeScreen(),
            _ => const FavoriteScreen()
          };
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: context.watch<IndexNavProvider>().indexBottomNavBar,
          onTap: (index) {
            context.read<IndexNavProvider>().setIndextBottomNavBar = index;
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: "Home", tooltip: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: "Favorite",
                tooltip: "Favorite"),
          ]),
    );
  }
}
