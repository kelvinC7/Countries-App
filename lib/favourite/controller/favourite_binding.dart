import 'package:countries/favourite/controller/favorite_controller.dart';
import 'package:get/get.dart';
import 'package:countries/data/local_storage.dart';
import 'package:countries/home/domain/repository/home_repo.dart';
import 'package:http/http.dart' as http;
import '../../data/api_client.dart';

class FavoritesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FavoritesController(
          localStorage: Get.find<LocalStorage>(),
          repository: Get.find<HomeRepository>(),
        ));
  
    Get.lazyPut(() => http.Client());
    Get.lazyPut(() => HomeRepository(apiClient: Get.find()));
    Get.lazyPut(() => LocalStorage());
  }
}
