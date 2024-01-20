import 'package:flutter/material.dart';
import 'package:secure_connect/components/background_template.dart';
import 'package:secure_connect/constants/app_strings.dart';

class LastLoginView extends StatelessWidget {
  const LastLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      headerText: AppStrings.lastLogin,
      child: Container(),
    );
  }
}
