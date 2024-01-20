import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final void Function() onTap;
  const CustomButton({
    required this.onTap,
    required this.buttonText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08),
        decoration: const BoxDecoration(
            color: Color(0xFF333333),
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            )),
        height: MediaQuery.of(context).size.height * 0.07,
        child: Center(
          child: Text(
            buttonText,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor),
          ),
        ),
      ),
    );
  }
}
