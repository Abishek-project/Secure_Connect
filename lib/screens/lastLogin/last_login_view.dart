import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:secure_connect/components/background_template.dart';
import 'package:secure_connect/components/common_functions.dart';
import 'package:secure_connect/constants/app_colors.dart';
import 'package:secure_connect/constants/app_strings.dart';
import 'package:secure_connect/constants/app_typography.dart';
import 'package:secure_connect/screens/lastLogin/last_login_view_controller.dart';

class LastLoginView extends GetView<LastLoginController> {
  LastLoginView({super.key}) {
    controller.init();
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      logoutOnTap: () => CommonWidgetFunctions.logout(),
      isLogout: true,
      headerText: AppStrings.lastLogin,
      isBackArrow: true,
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.zero,
              child: tabBarHeader(context),
            ),
            Obx(() => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 34),
                    child: tabView(),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  TabBar tabBarHeader(BuildContext context) {
    return TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      onTap: (value) {
        controller.fetchData();
      },
      indicatorWeight: 4,
      indicatorColor: AppColors.textColor,
      padding: EdgeInsets.zero,
      labelPadding:
          EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.15),
      indicatorSize: TabBarIndicatorSize.label,
      indicatorPadding: EdgeInsets.zero,
      tabs: const [
        Tab(
          text: AppStrings.today,
        ),
        Tab(
          text: AppStrings.yesterday,
        ),
        Tab(
          text: AppStrings.other,
        ),
      ],
    );
  }

  TabBarView tabView() {
    return TabBarView(
      children: [
        MyView(
          data: controller.todayData,
          loading: controller.isLoading.value,
        ),
        MyView(
          data: controller.yesterdayData,
          loading: controller.isLoading.value,
        ),
        MyView(
          data: controller.otherData,
          loading: controller.isLoading.value,
        ),
      ],
    );
  }
}

class MyView extends StatelessWidget {
  final RxList data;
  final bool loading;

  const MyView({super.key, required this.data, required this.loading});

  @override
  Widget build(BuildContext context) {
    if (loading == true) {
      return const Center(child: CircularProgressIndicator());
    } else if (data.isEmpty) {
      return Center(
          child: Text(AppStrings.noDataAvailable,
              style: AppTypography.appMediumText
                  .copyWith(color: AppColors.textColor)));
    } else {
      return _buildTabView(data);
    }
  }
}

Widget _buildTabView(RxList data) {
  return ListView.builder(
    itemCount: data.length,
    itemBuilder: (context, index) {
      var item = data[index];
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 30),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: AppColors.greyDarkColor,
                borderRadius: const BorderRadius.all(Radius.circular(12))),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        _formatTime(item['loginTime'] as Timestamp),
                        style: const TextStyle(color: AppColors.textColor),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        'ip: ${item['ipAddress']}',
                        style: const TextStyle(color: AppColors.textColor),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        '${item['location']}',
                        style: const TextStyle(color: AppColors.textColor),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          item['qrCodeImage'] != null
              ? Positioned(
                  right: 0,
                  bottom: 30,
                  child: Container(
                    // padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.textColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: QrImageView(
                      data: item['qrCodeImage'] ?? '',
                      version: QrVersions.auto,
                      size: 90.0,
                    ),
                  ),
                )
              : Container(),
        ],
      );
    },
  );
}

String _formatTime(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  int hour = dateTime.hour % 12;
  hour = hour == 0 ? 12 : hour;
  String minute = dateTime.minute.toString().padLeft(2, '0');
  String period = dateTime.hour < 12 ? 'AM' : 'PM';
  return '$hour:$minute $period';
}
