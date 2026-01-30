import 'package:countries/detail/screen/detail_screen.dart';
import 'package:countries/splash/splash_screen.dart';
import 'package:get/get.dart';

import '../common/widgets/main_screen.dart';
import '../detail/controller/detail_binding.dart';
import '../favourite/controller/favourite_binding.dart';
import '../favourite/screen/favourite_screen.dart';

class RouteHelper {
  static const String splash = '/splash';
  static const String main = '/main';
  static const String details = '/details/:code';
  static const String favorites = '/favorites';

  static getSplashRoute() => splash;
  static getMainRoute() => main;
  static getDetailsRoute(String code) => '/details/$code';
  static getFavoritesRoute() => favorites;

  static List<GetPage> routes = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: main,
      page: () =>const  MainScreen(),
    ),
    
    GetPage(
      name: details,
      page: () {
        final code = Get.parameters['code'] ?? '';
        return CountryDetailScreen(countryCode: code);
      },
      binding: DetailBinding(),
    ),
    
  GetPage(
    name: favorites,
    page: () => const FavoritesScreen(),
    binding: FavoritesBinding(), // Add this
  ),
  ];
}