import 'package:flutter/material.dart';
import 'package:secure_connect/components/background_template.dart';
import 'package:secure_connect/constants/app_strings.dart';

class PluginView extends StatelessWidget {
  const PluginView({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
        headerText: AppStrings.pluginText, child: Container());
  }
}
