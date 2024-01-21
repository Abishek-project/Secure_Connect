import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_connect/components/background_template.dart';
import 'package:secure_connect/components/common_functions.dart';
import 'package:secure_connect/constants/app_colors.dart';
import 'package:secure_connect/constants/app_strings.dart';
import 'package:secure_connect/constants/app_typography.dart';
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
        isBackArrow: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                phoneTextFieldHeader(),
                const SizedBox(
                  height: 10,
                ),
                phoneNumberTextField(),
                const SizedBox(
                  height: 25,
                ),
                otpTextFieldHeader(),
                const SizedBox(
                  height: 10,
                ),
                otpTextField(),
                loginButtonWidget(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding loginButtonWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08),
      child: CustomButton(
        onTap: () async {
          if (controller.formKey.currentState!.validate()) {
            await controller
                .signInWithPhoneNumber(controller.otpController.text.trim());
          }
        },
        buttonText: AppStrings.login,
      ),
    );
  }

  CustomTextField otpTextField() {
    return CustomTextField(
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
    );
  }

  Row otpTextFieldHeader() {
    return Row(
      children: [
        Text(
          AppStrings.otp,
          style:
              AppTypography.appMediumText.copyWith(color: AppColors.textColor),
        ),
      ],
    );
  }

  CustomTextField phoneNumberTextField() {
    return CustomTextField(
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
          CommonWidgetFunctions.showAlertSnackbar(
              AppStrings.emptyField,
              AppStrings.enterYourNumber,
              AppColors.redColor,
              AppColors.textColor,
              1);
        } else if (!controller.regex.hasMatch(value)) {
          CommonWidgetFunctions.showAlertSnackbar(
              AppStrings.invalidNumber,
              AppStrings.enterValidNumber,
              AppColors.redColor,
              AppColors.textColor,
              1);
        } else {
          controller
              .verifyPhoneNumber(controller.phoneNumberController.text.trim());
        }
      },
    );
  }

  Row phoneTextFieldHeader() {
    return Row(
      children: [
        Text(
          AppStrings.phoneNumber,
          style:
              AppTypography.appMediumText.copyWith(color: AppColors.textColor),
        ),
      ],
    );
  }
}
