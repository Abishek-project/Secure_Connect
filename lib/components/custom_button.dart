import 'package:flutter/material.dart';
import 'package:secure_connect/constants/app_typography.dart';
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
        decoration: BoxDecoration(
            color: AppColors.grey01Color,
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            )),
        height: MediaQuery.of(context).size.height * 0.07,
        child: Center(
            child: Text(buttonText,
                style: AppTypography.appMediumBoldText
                    .copyWith(color: AppColors.textColor))),
      ),
    );
  }
}
