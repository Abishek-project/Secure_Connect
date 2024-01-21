import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
}
