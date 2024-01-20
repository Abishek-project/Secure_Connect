import 'package:get/get.dart';
import 'package:secure_connect/constants/app_paths.dart';
import 'package:secure_connect/screens/lastLogin/last_login_view.dart';
import 'package:secure_connect/screens/lastLogin/last_login_view_bindings.dart';
import 'package:secure_connect/screens/login/login_view_bindings.dart';
import 'package:secure_connect/screens/pluginView/plugin_view.dart';
import 'package:secure_connect/screens/pluginView/plugin_view_bindings.dart';

import '../screens/login/login_view.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: AppPaths.login,
      page: (() => LoginView()),
      binding: LoginViewBindings(),
    ),
    GetPage(
      name: AppPaths.lastLogin,
      page: (() => LastLoginView()),
      binding: LastLoginBindings(),
    ),
    GetPage(
      name: AppPaths.plugin,
      page: (() => PluginView()),
      binding: PluginBindings(),
    ),
  ];
}
