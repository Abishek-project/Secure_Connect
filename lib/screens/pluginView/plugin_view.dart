import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_connect/components/background_template.dart';
import 'package:secure_connect/constants/app_strings.dart';
import 'package:secure_connect/screens/pluginView/plugin_view_controller.dart';

class PluginView extends GetView<PluginController> {
  const PluginView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: CommonBackground(
          isLogout: true,
          logoutOnTap: () => controller.logout(),
          headerText: AppStrings.pluginText,
          child: Container()),
    );
  }
}
