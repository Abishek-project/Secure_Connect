import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_connect/components/background_template.dart';
import 'package:secure_connect/constants/app_colors.dart';
import 'package:secure_connect/constants/app_strings.dart';
import 'package:secure_connect/screens/pluginView/plugin_view.dart';
import 'package:secure_connect/screens/pluginView/plugin_view_bindings.dart';
import '../../components/custom_button.dart';
import '../../components/custom_textfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      headerText: AppStrings.login,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              children: [
                Text(
                  AppStrings.phoneNumber,
                  style: TextStyle(fontSize: 20, color: AppColors.textColor),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const CustomTextField(),
            const SizedBox(
              height: 25,
            ),
            const Row(
              children: [
                Text(
                  AppStrings.otp,
                  style: TextStyle(fontSize: 20, color: AppColors.textColor),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const CustomTextField(),
            CustomButton(
              onTap: () {
                Get.to(const PluginView(), binding: PluginBindings());
              },
              buttonText: AppStrings.login,
            )
          ],
        ),
      ),
    );
  }
}
