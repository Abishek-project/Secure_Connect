import 'package:flutter/material.dart';
import 'package:secure_connect/constants/app_colors.dart';
import 'package:secure_connect/constants/app_strings.dart';

class CommonBackground extends StatelessWidget {
  final Widget child;
  const CommonBackground({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0XFF2d2c5c),
      body: Stack(
        children: [
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
                child: const Center(
                  child: Text(
                    AppStrings.login,
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
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
            ),
          )
        ],
      ),
    );
  }
}
