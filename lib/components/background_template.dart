import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_connect/constants/app_colors.dart';
import 'package:secure_connect/constants/app_strings.dart';
import 'package:secure_connect/constants/app_typography.dart';

class CommonBackground extends StatelessWidget {
  final String headerText;
  final Widget child;
  final bool isLogout;
  final bool isBackArrow;
  final void Function()? logoutOnTap;
  const CommonBackground(
      {required this.child,
      required this.headerText,
      required this.isLogout,
      required this.isBackArrow,
      this.logoutOnTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0XFF2d2c5c),
      body: Stack(
        children: [
          isBackArrow
              ? Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.height * 0.01,
                    top: MediaQuery.of(context).size.height * 0.03,
                  ),
                  child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.textColor,
                      )),
                )
              : Container(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(34),
                    topRight: Radius.circular(34),
                  ),
                ),
                height: MediaQuery.of(context).size.height * 0.89,
                child: child),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.09,
            right: 0,
            left: 0,
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.35,
                decoration: BoxDecoration(
                  color: Colors.blue.shade400,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Center(
                  child: Text(headerText,
                      style: AppTypography.appMediumText02
                          .copyWith(color: Colors.white)),
                ),
              ),
            ),
          ),
          Positioned(
            top: -MediaQuery.of(context).size.height * 0.079,
            right: -MediaQuery.of(context).size.width * 0.06,
            child: Container(
              height: MediaQuery.of(context).size.width * 0.38,
              width: MediaQuery.of(context).size.width * 0.38,
              decoration: const BoxDecoration(
                  color: AppColors.whiteLight, shape: BoxShape.circle),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.08,
                  ),
                  child: isLogout
                      ? InkWell(
                          onTap: logoutOnTap,
                          child: Text(AppStrings.logout,
                              style: AppTypography.appMediumText
                                  .copyWith(color: AppColors.textColor)),
                        )
                      : Container(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
