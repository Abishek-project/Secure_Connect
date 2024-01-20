import 'package:get/get.dart';
import 'last_login_view_controller.dart';

class LastLoginBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LastLoginController>(() => LastLoginController());
  }
}
