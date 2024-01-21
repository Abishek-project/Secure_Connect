import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:secure_connect/components/background_template.dart';
import 'package:secure_connect/components/common_functions.dart';
import 'package:secure_connect/components/custom_button.dart';
import 'package:secure_connect/constants/app_colors.dart';
import 'package:secure_connect/constants/app_paths.dart';
import 'package:secure_connect/constants/app_strings.dart';
import 'package:secure_connect/screens/pluginView/plugin_view_controller.dart';

class PluginView extends GetView<PluginController> {
  PluginView({super.key}) {
    controller.init();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: CommonBackground(
        isLogout: true,
        logoutOnTap: () => CommonWidgetFunctions.logout(),
        headerText: AppStrings.pluginText,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  DiagonalSplitCard(
                    generatedString: controller.generatedString.value,
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        FutureBuilder<String>(
                          future: controller.getLastLogin(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    border: Border.all(
                                        width: 1, color: AppColors.textColor),
                                  ),
                                  child: const Center(
                                      child: CircularProgressIndicator()));
                            } else if (snapshot.hasError) {
                              // If there's an error, show an error message
                              return Text("Error: ${snapshot.error}");
                            } else {
                              // If the Future is complete, display the result
                              return InkWell(
                                onTap: () {
                                  Get.toNamed(AppPaths.lastLogin);
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    border: Border.all(
                                        width: 1, color: AppColors.textColor),
                                  ),
                                  child: Center(
                                    child: Text(
                                      snapshot.data ??
                                          "No previous logins", // Show the result
                                      style: const TextStyle(
                                          color: AppColors.textColor,
                                          fontSize: 18),
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: CustomButton(
                              onTap: () async {
                                await controller.updateQrCodeImage();
                              },
                              buttonText: AppStrings.save),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                child: Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.textColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: Obx(() => QrImageView(
                            data: controller.generatedString.value,
                            version: QrVersions.auto,
                            size: 180.0,
                          )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DiagonalSplitCard extends StatelessWidget {
  final String generatedString;
  const DiagonalSplitCard({super.key, required this.generatedString});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      height: 200,
      width: double.infinity,
      child: Stack(
        children: [
          // Left side (Green)
          Positioned.fill(
            child: ClipPath(
              clipper: LeftTriangleClipper(),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: ClipPath(
                clipper: RightTriangleClipper(),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Your content in the middle
          Positioned.fill(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Generated String',
                    style: TextStyle(
                      color: Colors.white,
                      // fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    generatedString,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 30.0,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LeftTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class RightTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height + 10)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
