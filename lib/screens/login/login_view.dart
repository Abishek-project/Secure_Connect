import 'package:flutter/material.dart';
import 'package:secure_connect/components/background_template.dart';
import 'package:secure_connect/constants/app_colors.dart';
import 'package:secure_connect/constants/app_strings.dart';
import '../../components/custom_button.dart';
import '../../components/custom_textfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CommonBackground(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  AppStrings.phoneNumber,
                  style: TextStyle(fontSize: 20, color: AppColors.textColor),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextField(),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Text(
                  AppStrings.otp,
                  style: TextStyle(fontSize: 20, color: AppColors.textColor),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextField(),
            CustomButton(
              buttonText: AppStrings.login,
            )
          ],
        ),
      ),
    );
  }
}
