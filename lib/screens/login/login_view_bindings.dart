import 'package:get/get.dart';
import 'package:secure_connect/screens/login/login_view_controller.dart';

class LoginViewBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginViewController>(() => LoginViewController());
  }
}
