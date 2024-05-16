import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hypee_content_creator/constants/app_colors.dart';
import 'package:hypee_content_creator/constants/app_paddings.dart';
import 'package:hypee_content_creator/controllers/profile_controllers/editor_profile_controller.dart';
import 'package:hypee_content_creator/controllers/user_controller.dart';
import 'package:hypee_content_creator/models/UserModel.dart';
import 'package:hypee_content_creator/views/dashboards/project_management_dashboard.dart';
import 'package:hypee_content_creator/views/dashboards/upload_project_files.dart';
import 'package:hypee_content_creator/views/ChatList.dart';
import 'package:hypee_content_creator/views/notification_screen.dart';
import 'package:hypee_content_creator/views/profile_screens/account_info.dart';
import 'package:hypee_content_creator/views/register_screens/login.dart';
import 'package:hypee_content_creator/widgets/app_text.dart';

import '../chat_screen.dart';

class EditorProfile extends StatelessWidget {
  EditorProfile({Key? key}) : super(key: key);
  UserModel currentUser = Get.find<UserController>().userModel.value;
   PlatformFile? pickedfile;
   PlatformFile? profile_pic;

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
              //onTap: () => Get.to(() => ChatScreen()),
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
          child: GetBuilder<EditorProfileController>(
              init: EditorProfileController(),
              builder: (controller) {
                return Padding(
                  padding: AppPaddings.defaultPadding,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Stack(
                            children: [
                             Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(70)
                              ),
                              child: controller.isLoading == true ? Center(
                                child: CircularProgressIndicator(),
                              ) :  Container(
                                 width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(70)
                              ),
                                child: currentUser.profile == null ? CircleAvatar(
                                radius: 70,
                                backgroundImage: AssetImage("assets/images/img1.png"),
                              ) : CircleAvatar(
                                radius: 70,
                                backgroundImage: NetworkImage(currentUser.profile.toString()),
                              ),
                              )
                             ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: ()async{
                                     pickedfile = await pickfiles();
              if(pickedfile != null){
                controller.changeprofilePic(pickedfile, currentUser);
              }  
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.5), // Shadow color
                                                  spreadRadius: 2, // Spread radius
                                                  blurRadius: 2, // Blur radius
                                                  offset: Offset(0, 1), // Offset in the x and y directions
                                                ),
                                              ],
                                            ),
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.edit, color: AppColors.primaryColor, size: 20,),
                                    ),
                                  ),
                                )
                                )
                            ],
                          ),
                        ),
                        AppPaddings.heightSpace20,
                        AppText(
                          text: currentUser.firstname.toString() + " " + currentUser.lastname.toString(),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        AppPaddings.heightSpace30,
                        Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Color(0xffFFF0EC),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppText(
                          text: "500",
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xffFF8463),
                        ),
                        AppPaddings.heightSpace5,
                         AppText(
                          text: "Wallet balance",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1D1B23),
                        ),
                              ],
                            ),
                          ),
                        ),
                        AppPaddings.heightSpace10,
                        AppText(
                          text: "Withdraw Now",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff462A8C),
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
                                onTap: ()async{
                                  if (index == 1) {
                                    Get.to(() => ChatList());
                                  } else if (index == 0) {
                                    Get.to(() => AccountInfo());
                                  }else if(index == 2){
                                    Get.to(() => ProjectManagementDashboard());
                                  }
                                  else if(index == 3){
                                    Get.to(() => ProjectManagementDashboard());
                                  }else if(index == controller.settingsList.length - 1){
                                    await controller.signOut();
                                    Get.to(()=>Login());
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
                  ),
                );
              }),
        ),
      ),
    );
  }
  Future<PlatformFile?> pickfiles() async{
   final result = await FilePicker.platform.pickFiles();
   if (result != null && result.files.isNotEmpty) {
    return result.files.first;
  } else {
    // No file selected, return null or handle the situation accordingly.
    return null;
  }
 }
}
