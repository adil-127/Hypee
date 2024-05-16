import 'dart:convert';

import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/bubbles/bubble_special_two.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hypee_content_creator/constants/api_constaints.dart';
import 'package:hypee_content_creator/constants/app_paddings.dart';
import 'package:hypee_content_creator/controllers/initialize_project_controller.dart';
import 'package:hypee_content_creator/controllers/user_controller.dart';
import 'package:hypee_content_creator/main.dart';
import 'package:hypee_content_creator/models/ChatRoomModel.dart';
import 'package:hypee_content_creator/models/MessageModel.dart';
import 'package:hypee_content_creator/models/ProjectModel.dart';
import 'package:hypee_content_creator/models/UserModel.dart';
import 'package:hypee_content_creator/views/dashboards/project_management_dashboard.dart';
import 'package:hypee_content_creator/views/dashboards/upload_project_files.dart';
import 'package:hypee_content_creator/widgets/app_input_field.dart';
import 'package:hypee_content_creator/widgets/chat_bubble.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../constants/app_colors.dart';
import '../widgets/app_text.dart';

class ChatScreen extends StatelessWidget {
  // targetuser=VideoEditor
   final UserModel targetUser;
  final ChatRoomModel chatroom;
  final UserModel userModel;
  final me = Get.find<UserController>();
  int? otherId;
  ChatScreen({Key? key, required this.targetUser, required this.chatroom, required this.userModel}) : super(key: key);
  TextEditingController messageController = TextEditingController();
   void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();

    if(msg != "") {
      // Send Message
      MessageModel newMessage = MessageModel(
        messageid: uuid.v1(),
        sender: this.userModel.id.toString(),
        createdon: DateTime.now(),
        text: msg,
        seen: false
      );

      FirebaseFirestore.instance.collection("chatrooms").doc(this.chatroom.chatroomid).collection("messages").doc(newMessage.messageid).set(newMessage.toMap());

      this.chatroom.lastMessage = msg;
      FirebaseFirestore.instance.collection("chatrooms").doc(this.chatroom.chatroomid).set(this.chatroom.toMap());

      print("Message Sent!");
    }
  }
  Future<List<ProjectModel>> checkProjectStatus()async{
    var participants = chatroom.participants;
    for (var entry in participants!.entries) {
    if (int.parse(entry.key) != me.userModel.value.id) {
      otherId = int.parse(entry.key);
    }
  }
    return await ProjectModel.getProjectsByQuery(status: "Pending", vc: me.userModel.value.id, ve: otherId);
  }

  @override
  Widget build(BuildContext context) {
    String role = me.userModel.value.role.toString();
    return SafeArea(
      child: role == "VC" ? FutureBuilder(
        future: checkProjectStatus(),
        builder: (context,snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(child: CircularProgressIndicator()),
            );
          }else{
            return Scaffold(
            backgroundColor: AppColors.backgroundColor,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: "Messenger Chat",
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  snapshot.data!.length > 0 ? AppText(
                    text: "",
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ) :
                  
                   InkWell(
                    onTap: () async{
                      initialize_project_controller project = initialize_project_controller(VE: targetUser, Vc:me.userModel.value );
                      int project_id = await  project.initializeProject();
                      String creatorName = this.userModel.firstname.toString() + this.userModel.lastname.toString();
                        final apiUrl = Uri.parse('https://fcm.googleapis.com/fcm/send');

  // Define the request headers (if needed)
  final headers = {
    'Content-Type': 'application/json',
    'Authorization' : 'key=$authorizationtoken'
    // Add any other headers if required
  };

  // Define the request body
  final requestBody = {
    "registration_ids": [
      targetUser.pushToken.toString()
    ],
    "notification": {
      "body": "$creatorName has started project with you.",
      "title": "Congragulations",
      "android_channel_id": "high_importance_channel",
      "sound": false
    }
  };

  // Send the POST request
  final response = await http.post(
    apiUrl,
    headers: headers,
    body: jsonEncode(requestBody),
  );

  // Check the response status
  if (response.statusCode == 200) {
    await Get.to(()=>ProjectManagementDashboard());
    print('Response data: ${response.body}');
    // You can parse and handle the response data here
  } else {
    print('Error: ${response.statusCode}');
    print('Error message: ${response.body}');
    // Handle the error response here
  }
                    },
                    child: AppText(
                      text: "Order Now",
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            body: Stack(
              children: [
                Padding(
                  padding: AppPaddings.defaultPadding,
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 38.0),
                          child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("chatrooms").doc(this.chatroom.chatroomid).collection("messages").orderBy("createdon", descending: true).snapshots(),
                        builder: (context,snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // Display a loading indicator while the messages are being fetched
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          // Handle the case where an error occurred while fetching the messages
                          return Text('Error loading messages');
                        } else {
                          // Use the retrieved messages to build the chat UI
                          QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
                          return ListView.builder(
                            reverse: true,
                            itemCount: dataSnapshot.docs.length,
                            itemBuilder: (context, index) {
                              MessageModel currentMessage = MessageModel.fromMap(dataSnapshot.docs[index].data() as Map<String, dynamic>);          
                              print(currentMessage.text);
                              DateTime messageTime = DateTime.parse(currentMessage.createdon.toString());
                              String formattedTime = DateFormat.jm().format(messageTime);

                              // Customize the ChatBubble widget according to your data structure
                              return ChatBubble(
                                time: formattedTime,
                                isSender: true,
                                msg: currentMessage.text,
                              );
                            },
                          );
                        }
                        },
                      ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 18.0,
                    ),
                    child: TextFormField(
                      controller: messageController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Enter Your Message",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SvgPicture.asset(
                            "assets/icons/Camera.svg",
                            width: 10,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        suffixIcon: InkWell(
                          onTap: (){
                            sendMessage();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SvgPicture.asset(
                              "assets/icons/send.svg",
                              width: 10,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
          }
        }
      ) 
      
      
      
      
      
      
      
      
      
      
      
      : Scaffold(
            backgroundColor: AppColors.backgroundColor,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: "Messenger Chat",
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  // AppText(
                  //   text: "Order Now",
                  //   color: AppColors.primaryColor,
                  //   fontWeight: FontWeight.w600,
                  // ),
                ],
              ),
            ),
            body: Stack(
              children: [
                Padding(
                  padding: AppPaddings.defaultPadding,
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 38.0),
                          child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("chatrooms").doc(this.chatroom.chatroomid).collection("messages").orderBy("createdon", descending: true).snapshots(),
                        builder: (context,snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // Display a loading indicator while the messages are being fetched
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          // Handle the case where an error occurred while fetching the messages
                          return Text('Error loading messages');
                        } else {
                          // Use the retrieved messages to build the chat UI
                          QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
                          return ListView.builder(
                            reverse: true,
                            itemCount: dataSnapshot.docs.length,
                            itemBuilder: (context, index) {
                              MessageModel currentMessage = MessageModel.fromMap(dataSnapshot.docs[index].data() as Map<String, dynamic>);          
                              print(currentMessage.text);
                              DateTime messageTime = DateTime.parse(currentMessage.createdon.toString());
                              String formattedTime = DateFormat.jm().format(messageTime);

                              // Customize the ChatBubble widget according to your data structure
                              return ChatBubble(
                                time: formattedTime,
                                isSender: true,
                                msg: currentMessage.text,
                              );
                            },
                          );
                        }
                        },
                      ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 18.0,
                    ),
                    child: TextFormField(
                      controller: messageController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Enter Your Message",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SvgPicture.asset(
                            "assets/icons/Camera.svg",
                            width: 10,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        suffixIcon: InkWell(
                          onTap: (){
                            sendMessage();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SvgPicture.asset(
                              "assets/icons/send.svg",
                              width: 10,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
