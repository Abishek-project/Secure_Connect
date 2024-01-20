import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_connect/constants/app_paths.dart';

import 'plugin_view_variables.dart';

class PluginController extends GetxController with PluginVariables {
  Future<void> logout() async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    await Future.delayed(const Duration(seconds: 1));
    try {
      await FirebaseAuth.instance.signOut();
      Get.back();
      Get.offAllNamed(AppPaths.login);
    } catch (e) {
      Get.back();
    }
  }
}
