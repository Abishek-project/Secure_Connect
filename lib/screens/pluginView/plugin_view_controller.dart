import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:secure_connect/components/common_functions.dart';
import 'package:secure_connect/constants/app_paths.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import 'plugin_view_variables.dart';

class PluginController extends GetxController with PluginVariables {
  Future<void> logout() async {
    CommonWidgetFunctions.showOverlayLoader();
    await Future.delayed(const Duration(seconds: 1));
    try {
      await FirebaseAuth.instance.signOut();
      Get.back();
      Get.offAllNamed(AppPaths.login);
    } catch (e) {
      Get.back();
      CommonWidgetFunctions.showAlertSnackbar(AppStrings.error,
          AppStrings.wentWrong, AppColors.redColor, AppColors.textColor, 3);
    }
  }
}
