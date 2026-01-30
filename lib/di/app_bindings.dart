import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:countries/data/api_client.dart';
import 'package:countries/data/local_storage.dart';
import 'package:countries/home/domain/repository/home_repo.dart';
import 'package:countries/detail/domain/repository/detail_repo.dart';
import 'package:countries/home/controller/home_controller.dart';

import '../favourite/controller/favorite_controller.dart';
import '../theme/theme_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // ===== Core Dependencies =====
    Get.lazyPut(() => http.Client(), fenix: true);
    Get.lazyPut(() => LocalStorage(), fenix: true);
    
    // ===== API & Repositories =====
    Get.lazyPut(() => ApiClient(
      client: Get.find<http.Client>(),
      localStorage: Get.find<LocalStorage>(),
    ), fenix: true);
    
    Get.lazyPut(() => HomeRepository(
      apiClient: Get.find<ApiClient>(),
    ), fenix: true);
    
    Get.lazyPut(() => DetailRepository(
      apiClient: Get.find<ApiClient>(),
    ), fenix: true);
    
    // ===== Controllers =====
    // These will be created when needed and disposed when not needed
    Get.lazyPut(() => HomeController(
      repository: Get.find<HomeRepository>(),
      localStorage: Get.find<LocalStorage>(),
    ));
    
    Get.lazyPut(() => FavoritesController(
      localStorage: Get.find<LocalStorage>(),
      repository: Get.find<HomeRepository>(),
    ));
    
    Get.put(ThemeController(), permanent: true);
  }
}