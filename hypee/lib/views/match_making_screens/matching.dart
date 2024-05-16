import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hypee_content_creator/constants/app_paddings.dart';
import 'package:hypee_content_creator/views/match_making_screens/matched.dart';

import '../../constants/app_colors.dart';
import '../../widgets/app_text.dart';

class Matching extends StatelessWidget {
  const Matching({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 3),
      (() => Get.to(() => Matched())),
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              onTap: () => Get.back(),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.arrow_back,
                ),
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          title: AppText(
            text: "Matching",
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 70,
                backgroundColor: Colors.white,
                child: Stack(
                  children: [
                    Center(
                      child: AppText(
                        text: "LOADING",
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SpinKitRing(
                      lineWidth: 10,
                      size: 150,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
              AppPaddings.heightSpace30,
              AppText(
                text: "We are matching you",
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
