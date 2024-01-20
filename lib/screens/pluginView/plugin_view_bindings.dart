import 'package:get/get.dart';
import 'package:secure_connect/screens/pluginView/plugin_view_controller.dart';

class PluginBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PluginController>(() => PluginController());
  }
}
