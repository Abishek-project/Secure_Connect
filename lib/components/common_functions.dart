import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_connect/constants/app_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

class CommonWidgetFunctions {
  static Future<void> showOverlayLoader() {
    return Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
  }

  static showAlertSnackbar(String headerText, String textContent,
      Color backgroundColor, Color textColor, int duration) {
    return Get.snackbar(
      headerText,
      textContent,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: textColor,
      snackStyle: SnackStyle.FLOATING,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.only(bottom: 30, right: 15, left: 15),
    );
  }

  static Future<void> logout() async {
    showOverlayLoader();
    await Future.delayed(const Duration(seconds: 1));
    try {
      await FirebaseAuth.instance.signOut();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      Get.back();
      Get.offAllNamed(AppPaths.login);
    } catch (e) {
      Get.back();
      CommonWidgetFunctions.showAlertSnackbar(AppStrings.error,
          AppStrings.wentWrong, AppColors.redColor, AppColors.textColor, 3);
    }
  }
}
