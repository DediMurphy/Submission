import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantapp/data/service/api_service.dart';
import 'package:restaurantapp/data/service/local_database_service.dart';
import 'package:restaurantapp/data/service/local_notification_service.dart';
import 'package:restaurantapp/data/service/shared_preferences_service.dart';
import 'package:restaurantapp/provider/detail/favorite_list_provider.dart';
import 'package:restaurantapp/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurantapp/provider/home/restaurant_list_provider.dart';
import 'package:restaurantapp/provider/home/search_restaurant_provider.dart';
import 'package:restaurantapp/provider/index_nav_provider.dart';
import 'package:restaurantapp/provider/local/local_database_provider.dart';
import 'package:restaurantapp/provider/notification/local_notification_provider.dart';
import 'package:restaurantapp/provider/theme/theme_provider.dart';
import 'package:restaurantapp/screen/detail/detail_screen.dart';
import 'package:restaurantapp/screen/main/main_screen.dart';
import 'package:restaurantapp/static/navigation_route.dart';
import 'package:restaurantapp/style/theme/restaurant_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final sharedPreferencesService = SharedPreferencesService(prefs);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => IndexNavProvider()),
        ChangeNotifierProvider(create: (context) => FavoriteListProvider()),
        Provider(create: (context) => ApiServices()),
        ChangeNotifierProvider(
          create: (context) => RestaurantListProvider(
            context.read<ApiServices>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => RestaurantDetailProvider(
            context.read<ApiServices>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchRestaurantProvider(
            context.read<ApiServices>(),
          ),
        ),
        Provider(create: (context) => LocalDatabaseService()),
        ChangeNotifierProvider(
          create: (context) => LocalDatabaseProvider(
            context.read<LocalDatabaseService>(),
          ),
        ),
        Provider(create: (context) => sharedPreferencesService),
        ChangeNotifierProvider(
          create: (context) =>
              ThemeProvider(context.read<SharedPreferencesService>()),
        ),
        Provider(
          create: (context) => LocalNotificationService()
            ..init()
            ..configureLocalTimeZone(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocalNotificationProvider(
            context.read<LocalNotificationService>(),
          )..requestPermissions(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: RestaurantTheme.lightTheme,
          darkTheme: RestaurantTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: NavigationRoute.mainRoute.name,
          routes: {
            NavigationRoute.mainRoute.name: (context) => const MainScreen(),
            NavigationRoute.detailRoute.name: (context) => DetailScreen(
                  restaurantId:
                      ModalRoute.of(context)!.settings.arguments as String,
                ),
          },
        );
      },
    );
  }
}
