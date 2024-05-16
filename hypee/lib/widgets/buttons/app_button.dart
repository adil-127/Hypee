import 'package:flutter/material.dart';
import 'package:hypee_content_creator/constants/app_colors.dart';

import '../app_text.dart';

class AppButton extends StatelessWidget {
  VoidCallback? onTap;
  Color? buttonColor, textColor, borderColor;
  String text;
  double? height, width;
  Widget? icon;

  AppButton({
    Key? key,
    this.onTap,
    required this.text,
    this.buttonColor,
    this.textColor,
    this.height,
    this.width,
    this.icon,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width ?? MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: buttonColor ?? AppColors.primaryColor,
          border: Border.all(
            color: borderColor ?? Colors.transparent,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon ?? const SizedBox(),
                icon != null
                    ? const SizedBox(
                        width: 10,
                      )
                    : const SizedBox(),
                AppText(
                  text: text,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
