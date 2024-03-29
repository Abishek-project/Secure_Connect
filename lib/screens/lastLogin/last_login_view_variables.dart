import 'package:get/get.dart';

mixin LastLoginVariables {
  var isLoading = true.obs;
  RxList<Map<String, dynamic>> todayData = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> yesterdayData = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> otherData = <Map<String, dynamic>>[].obs;
}
