import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hypee_content_creator/constants/app_paddings.dart';
import 'package:hypee_content_creator/controllers/buy_controller.dart';
import 'package:hypee_content_creator/controllers/user_controller.dart';
import 'package:hypee_content_creator/views/dashboards/project_management_dashboard.dart';
import 'package:hypee_content_creator/widgets/app_text.dart';
import 'package:hypee_content_creator/widgets/buttons/app_button.dart';
import 'package:hypee_content_creator/widgets/buttons/round_button.dart';

import '../../constants/app_colors.dart';

class AccountInfo extends StatelessWidget {
  AccountInfo({super.key});
  var currentUser = Get.find<UserController>().userModel.value;

  @override
   @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                text: currentUser.firstname.toString() + " " + currentUser.lastname.toString(),
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: GetBuilder<BuyController>(
            init: BuyController(),
            builder: (controller) {
              return Padding(
                padding: AppPaddings.defaultPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //             AppText(
            //               text: "About Me",
            //               fontWeight: FontWeight.w600,
            //               fontSize: 18,
            //             ),
            //             Container(
            //               decoration: BoxDecoration(
            //   shape: BoxShape.circle,
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.grey.withOpacity(0.5), // Shadow color
            //       spreadRadius: 2, // Spread radius
            //       blurRadius: 2, // Blur radius
            //       offset: Offset(0, 1), // Offset in the x and y directions
            //     ),
            //   ],
            // ),
            //               child: CircleAvatar(
            //                 radius: 20,
            //                 backgroundColor: Colors.white,
            //                 child: Center(
            //                   child: Icon(Icons.edit, size: 20, color: AppColors.primaryColor,),
            //                 ),
            //               ),
            //             )
            //           ],
            //         ),
            //         AppPaddings.heightSpace10,
            //          AppText(
            //               text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,",
            //               fontWeight: FontWeight.w400,
            //               fontSize: 18,
            //               color: Colors.black,
            //             ),
                        //AppPaddings.heightSpace30,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppText(
                          text: "Past Video Work Examples",
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                        Container(
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
                            child: Center(
                              child: Icon(Icons.edit, size: 20, color: AppColors.primaryColor,),
                            ),
                          ),
                        )
                      ],
                    ),
                    AppPaddings.heightSpace10,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          7,
                          (index) => Container(
                            height: 110,
                            width: 130,
                            margin: const EdgeInsets.only(
                              right: 20,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: const DecorationImage(
                                fit: BoxFit.cover,
                                image:
                                    AssetImage("assets/images/sampleimg.png"),
                              ),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/icons/play.svg",
                                width: 26,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    AppPaddings.heightSpace30,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppText(
                          text: "Video Editor's Skills",
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                        Container(
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
                            child: Center(
                              child: Icon(Icons.edit, size: 20, color: AppColors.primaryColor,),
                            ),
                          ),
                        )
                      ],
                    ),
                    AppPaddings.heightSpace10,
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(
                        currentUser.additionalFields!['skillType'].length,
                        (index) => RoundButton(
                          text: currentUser.additionalFields!['skillType'][index],
                        ),
                      ),
                    ),
                    AppPaddings.heightSpace40,
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //             AppText(
            //               text: "Payment Options",
            //               fontWeight: FontWeight.w600,
            //               fontSize: 18,
            //             ),
            //             Container(
            //               decoration: BoxDecoration(
            //   shape: BoxShape.circle,
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.grey.withOpacity(0.5), // Shadow color
            //       spreadRadius: 2, // Spread radius
            //       blurRadius: 2, // Blur radius
            //       offset: Offset(0, 1), // Offset in the x and y directions
            //     ),
            //   ],
            // ),
            //               child: CircleAvatar(
            //                 radius: 20,
            //                 backgroundColor: Colors.white,
            //                 child: Center(
            //                   child: Icon(Icons.edit, size: 20, color: AppColors.primaryColor,),
            //                 ),
            //               ),
            //             )
            //           ],
            //         ),
            //         SizedBox(
            //           height: 350,
            //           width: double.infinity,
            //           child: Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: GridView.builder(
            //               shrinkWrap: true,
            //               itemCount: 3,
            //               gridDelegate:
            //                   const SliverGridDelegateWithFixedCrossAxisCount(
            //                 crossAxisCount: 2,
            //                 mainAxisSpacing: 20,
            //                 crossAxisSpacing: 20,
            //               ),
            //               itemBuilder: (context, index) {
            //                 return Padding(
            //                   padding: const EdgeInsets.all(8.0),
            //                   child: Container(
            //                     decoration: BoxDecoration(
            //                       color: Colors.white,
            //                       borderRadius: BorderRadius.circular(15),
            //                       boxShadow: [
            //                         BoxShadow(
            //                           color: Colors.black.withOpacity(0.2),
            //                           offset: const Offset(2, 2),
            //                           spreadRadius: 2,
            //                           blurRadius: 10,
            //                         ),
            //                       ],
            //                     ),
            //                     child: Column(
            //                       mainAxisAlignment: MainAxisAlignment.center,
            //                       children: [
            //                         SizedBox(
            //                           height: 50,
            //                           width: 50,
            //                           child: Image.asset(
            //                             controller.paymentIcons[index],
            //                           ),
            //                         ),
            //                         AppPaddings.heightSpace10,
            //                         AppText(
            //                           text: controller.paymentOptions[index],
            //                           fontWeight: FontWeight.w500,
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                 );
            //               },
            //             ),
            //           ),
            //         ),
                    AppPaddings.heightSpace30,
                    AppPaddings.heightSpace30,
                    AppButton(
                      text: "Update",
                      onTap: () =>
                          Get.offAll(() => ProjectManagementDashboard()),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}