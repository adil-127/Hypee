import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hypee_content_creator/constants/app_colors.dart';
import 'package:hypee_content_creator/constants/app_paddings.dart';
import 'package:hypee_content_creator/controllers/buy_controller.dart';
import 'package:hypee_content_creator/controllers/user_controller.dart';
import 'package:hypee_content_creator/main.dart';
import 'package:hypee_content_creator/models/ChatRoomModel.dart';
import 'package:hypee_content_creator/models/UserModel.dart';
import 'package:hypee_content_creator/views/chat_screen.dart';
import 'package:hypee_content_creator/views/dashboards/project_management_dashboard.dart';
import 'package:hypee_content_creator/views/dashboards/upload_project_files.dart';
import 'package:hypee_content_creator/views/register_screens/sign_up.dart';
import 'package:hypee_content_creator/widgets/buttons/app_button.dart';
import 'package:hypee_content_creator/widgets/buttons/round_button.dart';
import 'package:hypee_content_creator/widgets/navbar.dart';

import '../widgets/app_text.dart';

class BuyScreen extends StatelessWidget {
  final UserModel matched_user;
  BuyScreen({Key? key, required this.matched_user}) : super(key: key);
  UserController me = Get.find<UserController>();
  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {
    ChatRoomModel? chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("chatrooms").where("participants.${this.me.userModel.value.id}", isEqualTo: true).where("participants.${targetUser.id}", isEqualTo: true).get();
    if(snapshot.docs.length > 0) {
      // Fetch the existing one
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom = ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatroom;
    }
    else {
      // Create a new one
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastMessage: "",
        participants: {
          this.me.userModel.value.id.toString(): true,
          targetUser.id.toString(): true,
        },
      );

      await FirebaseFirestore.instance.collection("chatrooms").doc(newChatroom.chatroomid).set(newChatroom.toMap());

      chatRoom = newChatroom;

      print("New Chatroom Created!");
    }

    return chatRoom;
  }
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
                text: "Join the ",
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(
                height: 30,
                width: 70,
                child: Image.asset("assets/images/logo.png"),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: GetBuilder<BuyController>(
            init: BuyController(),
            builder: (controller) {
              //controller.editorSkills[0] = matched_user
              return Padding(
                padding: AppPaddings.defaultPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: "Past Video Work Examples",
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
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
                    AppText(
                      text: "Video Editor’s Skills",
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                    AppPaddings.heightSpace10,
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: List.generate(
                        matched_user.additionalFields!['skillType'].length,
                        (index) => RoundButton(
                          text: matched_user.additionalFields!['skillType'][index],
                        ),
                      ),
                    ),
                    AppPaddings.heightSpace40,
                    AppText(
                      text: "Payment Options",
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                    SizedBox(
                      height: 350,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: 3,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                          ),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      offset: const Offset(2, 2),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: Image.asset(
                                        controller.paymentIcons[index],
                                      ),
                                    ),
                                    AppPaddings.heightSpace10,
                                    AppText(
                                      text: controller.paymentOptions[index],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    AppPaddings.heightSpace30,
                    Center(
                      child: AppText(
                        text: "“\$xxx:xx” as a cost before signing up",
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                    AppPaddings.heightSpace30,
                    AppButton(
                      text: "Subscribe",
                      onTap: ()async{
                        ChatRoomModel? chatroomModel = await getChatroomModel(matched_user);
                        print(chatroomModel!.participants);
                            if(chatroomModel != null) {
                              Get.to(() => ChatScreen(
                                    targetUser: matched_user,
                                    userModel: this.me.userModel.value,
                                    chatroom: chatroomModel,
                                  ));
                            }
                      }
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: Custom_navbar(),
      ),
    );
  }
}
