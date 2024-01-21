import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_connect/components/background_template.dart';
import 'package:secure_connect/constants/app_colors.dart';
import 'package:secure_connect/constants/app_strings.dart';
import 'package:secure_connect/screens/login/login_view_controller.dart';
import '../../components/custom_button.dart';
import '../../components/custom_textfield.dart';

class LoginView extends GetView<LoginViewController> {
  LoginView({super.key}) {
    controller.init();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when tapping outside
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: CommonBackground(
        isLogout: false,
        headerText: AppStrings.login,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Row(
                  children: [
                    Text(
                      AppStrings.phoneNumber,
                      style:
                          TextStyle(fontSize: 20, color: AppColors.textColor),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: controller.phoneNumberController,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppStrings.enterYourNumber;
                    } else if (!controller.regex.hasMatch(value)) {
                      return AppStrings.enterValidNumber;
                    }
                    return null;
                  },
                  onFieldSubmitted: (value) {
                    if (value.isEmpty) {
                      Get.snackbar(
                        AppStrings.emptyField,
                        AppStrings.enterYourNumber,
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        snackStyle: SnackStyle.FLOATING,
                        duration: const Duration(seconds: 1),
                        margin: const EdgeInsets.only(
                            bottom: 30, right: 15, left: 15),
                      );
                    } else if (!controller.regex.hasMatch(value)) {
                      Get.snackbar(
                        AppStrings.invalidNumber,
                        AppStrings.enterValidNumber,
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        snackStyle: SnackStyle.FLOATING,
                        duration: const Duration(seconds: 1),
                        margin: const EdgeInsets.only(
                            bottom: 30, right: 15, left: 15),
                      );
                    } else {
                      controller.verifyPhoneNumber(
                          controller.phoneNumberController.text.trim());
                    }
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                const Row(
                  children: [
                    Text(
                      AppStrings.otp,
                      style:
                          TextStyle(fontSize: 20, color: AppColors.textColor),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: controller.otpController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.enterOtp;
                    }

                    return null;
                  },
                ),
                CustomButton(
                  onTap: () async {
                    if (controller.formKey.currentState!.validate()) {
                      await controller.signInWithPhoneNumber(
                          controller.otpController.text.trim());
                    }
                  },
                  buttonText: AppStrings.login,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
