import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:countries/data/api_client.dart';
import 'package:countries/home/domain/repository/home_repo.dart';

import '../../data/local_storage.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => http.Client());
    Get.lazyPut(() => ApiClient(client: Get.find(), localStorage: Get.find<LocalStorage>()));
    Get.lazyPut(() => LocalStorage());
    Get.lazyPut(() => HomeRepository(apiClient: Get.find()));
    
  }
}
