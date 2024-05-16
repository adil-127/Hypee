import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hypee_content_creator/constants/app_colors.dart';
import 'package:hypee_content_creator/constants/app_paddings.dart';

import '../widgets/app_text.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
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
            text: "  Notifications ",
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: AppPaddings.defaultPadding,
            child: Column(
              children: List.generate(
                15,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: ListTile(
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    onTap: () {},
                    contentPadding: const EdgeInsets.only(
                      left: 5,
                      right: 10,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.lightGrey,
                      child: SvgPicture.asset("assets/icons/Notification.svg"),
                    ),
                    title: AppText(
                      text: "Robert Fox marked this project edited.",
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: AppText(
                      text: "text",
                      lineHeight: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
