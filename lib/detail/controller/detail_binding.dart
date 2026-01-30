import 'package:get/get.dart';
import 'package:countries/data/api_client.dart';
import 'package:countries/detail/domain/repository/detail_repo.dart';
import 'package:http/http.dart' as http;
import 'package:countries/home/domain/repository/home_repo.dart';
import '../../data/local_storage.dart';

class DetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiClient(client: http.Client(), localStorage: Get.find<LocalStorage>()));
    Get.lazyPut(() => DetailRepository(apiClient: Get.find()));
    Get.lazyPut(() => HomeRepository(apiClient: Get.find()));
    Get.lazyPut(() => LocalStorage());
  }
}
