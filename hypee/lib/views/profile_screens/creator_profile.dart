import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hypee_content_creator/constants/app_paddings.dart';
import 'package:hypee_content_creator/views/chat_screen.dart';
import 'package:hypee_content_creator/views/complete_project.dart';
import 'package:hypee_content_creator/views/dashboards/project_management_dashboard.dart';
import 'package:hypee_content_creator/views/dashboards/upload_project_files.dart';
import 'package:hypee_content_creator/views/register_screens/login.dart';
import 'package:hypee_content_creator/widgets/app_text.dart';
import 'package:hypee_content_creator/widgets/navbar.dart';

import '../../controllers/profile_controllers/creator_profile_controller.dart';
import '../notification_screen.dart';

class CreatorProfile extends StatelessWidget {
  const CreatorProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
             // onTap: () => Get.to(() => ChatScreen()),
              child: Padding(
                padding: const EdgeInsets.all(11.0),
                child: SvgPicture.asset("assets/icons/Chat.svg"),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: InkWell(
                onTap: () => Get.to(() => NotificationScreen()),
                child: Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: SvgPicture.asset("assets/icons/Notification.svg"),
                ),
              ),
            ),
          ],
          backgroundColor: Colors.transparent,
          title: AppText(
            text: "Profile",
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        body: Center(
          child: GetBuilder<CreatorProfileController>(
              init: CreatorProfileController(),
              builder: (controller) {
                return Padding(
                  padding: AppPaddings.defaultPadding,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 70,
                        backgroundImage: AssetImage("assets/images/img1.png"),
                      ),
                      AppPaddings.heightSpace20,
                      AppText(
                        text: "Jane Cooper",
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      AppPaddings.heightSpace30,
                      Column(
                        children: List.generate(
                          controller.settingsList.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: ListTile(
                              tileColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              onTap: () {
                                if(index == 1){
                                  Get.to(()=>ProjectManagementDashboard());
                                }else if(index == controller.settingsList.length - 1){
                                  Get.to(()=>Login());
                                }else if(index == 3){
                                  Get.to(()=>completeProjects());
                                }
                              },
                              contentPadding: const EdgeInsets.only(
                                left: 5,
                                right: 10,
                              ),
                              title: AppText(
                                text: controller.settingsList[index],
                                fontWeight: FontWeight.w500,
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }),
        ),
         bottomNavigationBar: Custom_navbar(),
      ),
    );
  }
}
