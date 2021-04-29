
import 'package:get/get.dart';
import 'package:locateme/Controllers/AuthController.dart';

class AuthBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }

}