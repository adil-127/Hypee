import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hypee_content_creator/controllers/user_controller.dart';
import 'package:hypee_content_creator/models/UserModel.dart';
import 'package:hypee_content_creator/views/ChatList.dart';
import 'package:hypee_content_creator/views/match_making_screens/matched.dart';
import '../controllers/navbar_controller.dart';
import '../constants/app_colors.dart';
import 'package:get/get.dart';

import '../views/profile_screens/creator_profile.dart';
import '../views/register_screens/login.dart';

class Custom_navbar extends StatelessWidget {
  UserModel currenrUser = Get.find<UserController>().userModel.value;
void _navigateToPage(int index) {
    switch (index) {
      case 0:
        Get.to(() => Matched()); // Replace with your route name for the Home page
        break;
      case 1:
         Get.to(() => Matched()); // Replace with your route name for the Search page
        break;
      case 2:
        Get.to(() => CreatorProfile()); // Replace with your route name for the Profile page
        break;
       case 3:
        Get.to(() => ChatList()); // Replace with your route name for the Profile page
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return GetBuilder<navbar_controller>(
            init: navbar_controller(),
            builder: (controller){
              return currenrUser.role == "VC" ? BottomNavigationBar(
          
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: Colors.black,
         onTap: (index) {
            controller.change_tab_index(index); // Update the selected index
            _navigateToPage(index); // Navigate to the selected page
          },
          
          currentIndex: controller.tab_index,
          showSelectedLabels: false,
          showUnselectedLabels: false,

          items:[
          BottomNavigationBarItem(
            icon: Stack(
              alignment: Alignment.bottomCenter,
              children: [
            Positioned(
              child: Container(
                height: 50,
             
                child: SvgPicture.asset("assets/icons/Home.svg",color: controller.tab_index == 0 ? AppColors.primaryColor : Colors.black,))),
          controller.tab_index==0 ?
          Positioned(
            top: 0,
            right: 9,

            child: Container(
              // margin: EdgeInsets.only(top: 6, right: 6),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.primaryColor, // Set the color of the dot
                shape: BoxShape.circle,
                      ),
                    ),
                  ):Text("")
               ]
                ),
                  label: "Home"
                    
                ),
                  








          
          BottomNavigationBarItem(icon: Stack(
              alignment: Alignment.bottomCenter,
              children: [
            Positioned(
              child: Container(
                height: 50,

                // color: Colors.amber,
             
                child: SvgPicture.asset("assets/icons/Search.svg",color: controller.tab_index == 1 ? AppColors.primaryColor : Colors.black,))),
            if (controller.tab_index==1)
          Positioned(
            top: 0,
            right: 9,

            child: Container(
              // margin: EdgeInsets.only(top: 6, right: 6),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.primaryColor, // Set the color of the dot
                shape: BoxShape.circle,
              ),
            ),
          ),
            ]
            ),
            label: "search"
            ),
          
          BottomNavigationBarItem(icon: Stack(
              alignment: Alignment.bottomCenter,
              children: [
            Positioned(
              child: Container(
                height: 50,
             
                child: SvgPicture.asset("assets/icons/Profile.svg",color: controller.tab_index == 2 ? AppColors.primaryColor : Colors.black,))),
            if (controller.tab_index==2)
          Positioned(
            top: 0,
            right: 9,

            child: Container(
              // margin: EdgeInsets.only(top: 6, right: 6),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.primaryColor, // Set the color of the dot
                shape: BoxShape.circle,
              ),
            ),
          ),
            ]
            ),
            label: "profile"
            ),
          BottomNavigationBarItem(icon: Stack(
              alignment: Alignment.bottomCenter,
              children: [
            Positioned(
              child: Container(
                height: 50,
             
                child: SvgPicture.asset("assets/icons/Chat.svg",color: controller.tab_index == 3  ? AppColors.primaryColor : Colors.black,))),
            if (controller.tab_index==3)
          Positioned(
            top: 0,
            right: 9,

            child: Container(
              // margin: EdgeInsets.only(top: 6, right: 6),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.primaryColor, // Set the color of the dot
                shape: BoxShape.circle,
              ),
            ),
          ),
            ]
            ),
            label: "profile"
            ),
          ],
              ) : 
              Container();
            }
    
    );
  }
}