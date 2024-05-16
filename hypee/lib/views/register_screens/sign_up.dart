import 'dart:io';

import 'package:file_picker/file_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_paddings.dart';
import '../../controllers/register_controllers/sign_up_controller.dart';
import '../../widgets/buttons/app_button.dart';
import '../../widgets/app_input_field.dart';
import '../../widgets/app_text.dart';
import '../match_making_screens/matching.dart';
import 'login.dart';

class SignUp extends StatelessWidget {
  
  SignUp({Key? key}) : super(key: key);

  TextEditingController _username = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _video_duration = new TextEditingController();
  TextEditingController _monthly_budget = new TextEditingController();
  TextEditingController firstname = new TextEditingController();
  TextEditingController lastname = new TextEditingController();
  TextEditingController influencerStyle1 = new TextEditingController();
  TextEditingController influencerStyle2 = new TextEditingController();
  TextEditingController influencerStyle3 = new TextEditingController();
  TextEditingController phonenumber = new TextEditingController();
  List<String> influencerStyles = [];
  Map<String,dynamic> signUp_credentials = {};
  VoidCallback? onTap;
  PlatformFile? pickedfile;
  PlatformFile? profile_pic;
  void Function(dynamic value)? changeSoftwareType, changeSkillType;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: AppText(
            text: "SignUp",
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: AppPaddings.defaultPadding,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Center(
              child: GetBuilder<SignUpController>(
                  init: SignUpController(),
                  builder: (controller) {
                    return controller.isLoading == true ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child:  CircleAvatar(
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
                      ),
                    ) : Form(
                       autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: controller.loginFormKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                            width: 120,
                            child: Image.asset("assets/images/logo.png"),
                          ),
                          AppPaddings.heightSpace30,
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundImage: controller.profile_pic == null ?  AssetImage("assets/images/img1.png") : FileImage(File(controller.profile_pic!.path!)) as ImageProvider<Object>?,
                                  ),
                                  Positioned(
                                    child: InkWell(
                                      onTap: ()async{
                                        profile_pic = await pickfiles();
                                        controller.selectProfilepic(profile_pic);
                                      },
                                      child: CircleAvatar(
                                        radius: 20,
                                        child: Center(child: Icon(Icons.camera_alt)),
                                      ),
                                    ),
                                    right: 0,
                                    bottom: 0, 
                                  )
                                ],
                              ),
                            ),
                          ),
                          AppPaddings.heightSpace30,
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: const Color.fromARGB(255, 255, 255, 255),
                              border: Border.all(
                                color: AppColors.backgroundColor,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppButton(
                                  onTap: () => controller.changeIndex(0),
                                  text: "Content Creator",
                                  buttonColor: controller.selectedIndex == 0
                                      ? AppColors.primaryColor
                                      : AppColors.lightGrey,
                                  textColor: controller.selectedIndex == 0
                                      ? Colors.white
                                      : AppColors.primaryColor,
                                  width: MediaQuery.of(context).size.width * 0.4,
                                ),
                                AppButton(
                                  onTap: () => controller.changeIndex(1),
                                  text: "Video Editor",
                                  buttonColor: controller.selectedIndex == 1
                                      ? AppColors.primaryColor
                                      : AppColors.lightGrey,
                                  textColor: controller.selectedIndex == 1
                                      ? Colors.white
                                      : AppColors.primaryColor,
                                  width: MediaQuery.of(context).size.width * 0.4,
                                ),
                              ],
                            ),
                          ),
                          AppPaddings.heightSpace30,
                          AppInputField(
                            title: "Firstname",
                            hintText: "Enter Firstname",
                            controller: firstname,
                          ),
                          AppPaddings.heightSpace30,
                           AppInputField(
                            title: "Lastname",
                            hintText: "Enter Lastname",
                            controller: lastname,
                          ),
                          AppPaddings.heightSpace30,
                          AppInputField(
                            title: "Username",
                            hintText: "Enter Username",
                            controller: _username,
                            validator: (value) {
                      return controller.validateEmail(value!);
                    },
                          ),
                          controller.selectedIndex == 0
                              // ? CreatorSignUp(
                              //     allCategories: controller.allCategories,
                              //     allVideoTypes: controller.allVideoTypes,
                              //     selectedCategory: controller.selectedCategory,
                              //     selectedVideoType: controller.selectedVideoType,
                              //     changeCat: (value) =>
                              //         controller.changeCat(value),
                              //     changeVideoType: (value) =>
                              //         controller.changeVideoType(value),
                              //   )
                              ? creatorSignUp(context)
                              : editorSignUp(
                                context,
                                controller.allSoftwareTypes,
                                controller.allSkillTypes,
                                "",
                                "",
                              ),
                              // : EditorSignUp(
                              //   allSoftwareTypes: controller.allSoftwareTypes, allSkillsTypes: controller.allSkillTypes, selectedSkillType: controller.selectedSkillType, selectedSoftwareType: controller.selectedSoftwareType),
                          AppPaddings.heightSpace30,
                          AppInputField(
                            obsecuretext: controller.obsecuretext,
                            controller: _password,
                            title: "Password",
                            hintText: "Enter Password",
                            suffixIcon: controller.obsecuretext == true ?  InkWell(
                            onTap: (){
                              controller.isShowPassword(false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child:
                                  SvgPicture.asset("assets/icons/visibility.svg"),
                            ),
                          ) : InkWell(
                            onTap: (){
                              controller.isShowPassword(true);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child:
                                  Icon(Icons.visibility_off),
                            ),
                          ),
                            validator: (value){
                              return controller.validatePassword(value);
                            },
                          ),
                          AppPaddings.heightSpace10,
                          Align(
                            alignment: Alignment.bottomRight,
                            child: AppText(
                              text: "Forget Password?",
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          AppPaddings.heightSpace30,
                          AppButton(
                            height: 55,
                            text: "Sign Up",
                            onTap: () {
                              //print(username);
                              controller.checkSignup();
                              if(controller.isValid){
                                if(controller.selectedIndex == 0){
                                var uc = {"Firstname":firstname.text,"Lastname":lastname.text,"email":_username.text, "password":_password.text, "video_duration":double.parse(_video_duration.text),"monthly_budget":double.parse(_monthly_budget.text),"role":"VC", "influencerStyles":influencerStyles, "phonenumber":phonenumber.text};
                              var user  = controller.signUp(uc,null,controller.profile_pic);
                              if(user != null){
                                Get.to(() => Login());
                              }
                              }else{
                                print(changeSoftwareType);
                                Map<String,dynamic> uc = {"Firstname":firstname.text,"Lastname":lastname.text,"email":_username.text, "password":_password.text, "softType":controller.selectedSoftwareType,"skillType":controller.selectedSkillType,"role":"VE"};
                              var user  = controller.signUp(uc,pickedfile,controller.profile_pic);
                              if(user != null){
                                Get.to(() => Login());
                              }
                              }
                              }
                            },
                          ),
                          AppPaddings.heightSpace30,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppText(
                                text: "Already have account?",
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                              InkWell(
                                onTap: () => Get.off(() => Login()),
                                child: AppText(
                                  text: "Login",
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          AppPaddings.heightSpace30,
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  thickness: 1.5,
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: AppText(text: "OR"),
                              ),
                              const Expanded(
                                child: Divider(
                                  thickness: 1.5,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          // AppPaddings.heightSpace30,
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     AppButton(
                          //       width: MediaQuery.of(context).size.width * 0.4,
                          //       text: "Google",
                          //       textColor: AppColors.primaryColor,
                          //       buttonColor: AppColors.lightGrey,
                          //       icon: SvgPicture.asset("assets/icons/google.svg"),
                          //       onTap: (){
                          //        controller.signInWithGoogle().then((User) => {
                          //         //print(User.additionalUserInfo),
                          //         if(User != null){
                          //           //Get.to(() => Matching())
                          //           print(User)
                          //         }
                          //        });
                          //     },
                          //     ),
                          //     AppButton(
                          //       width: MediaQuery.of(context).size.width * 0.4,
                          //       text: "Apple",
                          //       textColor: AppColors.primaryColor,
                          //       buttonColor: AppColors.lightGrey,
                          //       icon: SvgPicture.asset("assets/icons/apple.svg"),
                          //     ),
                          //   ],
                          // ),
                          // AppPaddings.heightSpace30,
                          // AppButton(
                          //       width: MediaQuery.of(context).size.width,
                          //       text: "Facebook",
                          //       textColor: AppColors.primaryColor,
                          //       buttonColor: AppColors.lightGrey,
                          //       icon: SvgPicture.asset("assets/icons/facebook.svg"),
                          //       onTap: (){
                          //         var user = controller.signInWithFacebook();
                          //         print(user);
                          //       },
                          //     ),
                          AppPaddings.heightSpace30,
                          AppText(
                            text: "Help",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }

  Widget creatorSignUp(BuildContext context) {
    return GetBuilder<SignUpController>(
      init: SignUpController(),
      builder: (controller){
        return Column(
        children: [
          AppPaddings.heightSpace30,
          AppInputField(
            controller: _video_duration,
            title: "Mins of Videos Need to Edit",
            hintText: "00 Mins",
            
            validator: (value){
              controller.validateDuration(value);
            },
          ),
          AppPaddings.heightSpace30,
          AppInputField(
            controller: _monthly_budget,
            title: "Monthly Budget",
            hintText: "\$200",
            //controller: signUp._monthly_budget,
          ),
          AppPaddings.heightSpace30,
           AppInputField(
             controller: phonenumber,
          title: "Phonenumber",
          hintText: "Enter Phonenumer",
        ),
          AppPaddings.heightSpace30,
           AppInputField(
            controller: influencerStyle1,
          title: "Influencer Video Style You Admire ",
          hintText: "Influencer Username 1",
        ),
        AppInputField(
           controller: influencerStyle2,
          hintText: "Influencer Username 2",
        ),
        AppInputField(
           controller: influencerStyle3,
          hintText: "Influencer Username 3",
        ),
        ],
      );
      },
    );
    }
    Widget editorSignUp(BuildContext context, List<String> allSoftwareTypes, List<String> allSkillsTypes, String selectedSoftwareType,String selectedSkillType) {
    return GetBuilder<SignUpController>(
      init: SignUpController(),
      builder: (controller){
        return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppPaddings.heightSpace30,
          AppText(
            text: "Submit Samples of Your Work",
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          AppPaddings.heightSpace10,
          AppButton(
            text: "Upload Here",
            icon: SvgPicture.asset("assets/icons/Upload.svg"),
            borderColor: Colors.grey,
            buttonColor: Colors.transparent,
            textColor: Colors.grey,
            onTap: () async{
              pickedfile = await pickfiles();
              if(pickedfile != null){
                controller.changefileName(pickedfile!.name);
              }           
            }
          ),
          AppPaddings.heightSpace5,
          controller.isUpload == true ?        
          Text(
            controller.filename,
            style: TextStyle(
              color: Colors.grey
            ),
          ) : Text(""),
          AppPaddings.heightSpace30,
          AppDropdownField(
           selectedValue: ["Soft 1"],
            items: allSoftwareTypes,
            onChanged: (value) {
              controller.selectedSkillType = value;
              //print(controller.selectedSkillType);
            },
            title: "Softwares You Know How to Use",
            hintText: "Select Type",
          ),
          AppPaddings.heightSpace30,
          AppDropdownField(
            selectedValue: ["Skill 1"],
            items: allSkillsTypes,
            onChanged: (value) {
              controller.selectedSkillType = value;
             // print(controller.selectedSkillType);
            },
            title: "Edits You Are Skilled at Making",
            hintText: "Select Type",
          ),
        ],
      );
      },
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

class CreatorSignUp extends StatelessWidget {
  String selectedCategory, selectedVideoType;

  List<String> allCategories, allVideoTypes;
  void Function(dynamic value)? changeCat, changeVideoType;
  CreatorSignUp({
    Key? key,
    required this.allCategories,
    required this.allVideoTypes,
    this.changeCat,
    this.changeVideoType,
    required this.selectedCategory,
    required this.selectedVideoType,
  }) : super(key: key);
  SignUpController signUpController = new SignUpController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppPaddings.heightSpace30,
        AppInputField(
          controller: signUpController.video_duration,
          title: "Mins of Videos Need to Edit",
          hintText: "00 Mins",
        ),
        AppPaddings.heightSpace30,
        AppInputField(
          title: "Monthly Budget",
          hintText: "\$200",
          //controller: signUp._monthly_budget,
        ),
      ],
    );
  }
}

// class EditorSignUp extends StatelessWidget {
//   String selectedSoftwareType, selectedSkillType;

//   List<String> allSoftwareTypes, allSkillsTypes;
//   VoidCallback? onTap;
//   void Function(dynamic value)? changeSoftwareType, changeSkillType;
//   EditorSignUp({
//     Key? key,
//     required this.allSoftwareTypes,
//     required this.allSkillsTypes,
//     this.changeSkillType,
//     this.changeSoftwareType,
//     required this.selectedSkillType,
//     required this.selectedSoftwareType,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         AppPaddings.heightSpace30,
//         AppText(
//           text: "Submit Samples of Your Work",
//           fontSize: 18,
//           fontWeight: FontWeight.w500,
//         ),
//         AppPaddings.heightSpace10,
//         AppButton(
//           text: "Upload Here",
//           icon: SvgPicture.asset("assets/icons/Upload.svg"),
//           borderColor: Colors.grey,
//           buttonColor: Colors.transparent,
//           textColor: Colors.grey,
//           onTap: onTap,
//         ),
//         AppPaddings.heightSpace30,
//         AppDropdownField(
//           selectedValue: selectedSoftwareType,
//           items: allSoftwareTypes,
//           onChanged: (value) {
//             changeSoftwareType;
//           },
//           title: "Softwares You Know How to Use",
//           hintText: "Select Type",
//         ),
//         AppPaddings.heightSpace30,
//         AppDropdownField(
//           selectedValue: selectedSkillType,
//           items: allSkillsTypes,
//           onChanged: (value) {
//             changeSkillType;
//           },
//           title: "Edits You Are Skilled at Making",
//           hintText: "Select Type",
//         ),
//       ],
//     );
//   }
// }
