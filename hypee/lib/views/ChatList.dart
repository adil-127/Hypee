import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hypee_content_creator/constants/app_colors.dart';
import 'package:hypee_content_creator/constants/app_paddings.dart';
import 'package:hypee_content_creator/controllers/manage_clients_controller.dart';
import 'package:hypee_content_creator/controllers/user_controller.dart';
import 'package:hypee_content_creator/models/ChatRoomModel.dart';
import 'package:hypee_content_creator/models/UserModel.dart';
import 'package:hypee_content_creator/views/chat_screen.dart';
import 'package:hypee_content_creator/views/profile_screens/creator_profile.dart';
import 'package:hypee_content_creator/widgets/app_text.dart';

class ChatList extends StatelessWidget {
  ChatList({Key? key}) : super(key: key);
  UserController currentUser = Get.find<UserController>();
  Future<List<UserModel>> getChatUsers()async{
    int? currentUserId = currentUser.userModel.value.id;
    var chatrooms = await FirebaseFirestore.instance.collection("chatrooms").where("participants.$currentUserId",isEqualTo: true).get();
    List<ChatRoomModel> getchatrooms = await chatrooms.docs.map((document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
     ChatRoomModel chatRoom = ChatRoomModel.fromMap(data);
      return chatRoom;
    }).toList();
     List<UserModel> chatUsers = [];
    for (ChatRoomModel chatroom in getchatrooms) {
    for (var entry in chatroom.participants!.entries) {
      String key = entry.key;
      bool value = entry.value;
      if (key != currentUser.userModel.value.id.toString() && value == true) {
        var getUser = await FirebaseFirestore.instance.collection("UsersData").where("id", isEqualTo: int.parse(key)).get();
        var data = getUser.docs.first.data() as Map<String, dynamic>;
        if(data['profile'] != null){
           FirebaseStorage ref = FirebaseStorage.instance;
           String filepath = data['profile'];
           var pathRef = await ref.ref(filepath);
           var downloadUrl = await pathRef.getDownloadURL();
           data['profile'] = downloadUrl.toString();
        }else{
          data['profile'] = null;
        }
        UserModel user = UserModel.fromMap(data);
        chatUsers.add(user);
      }
    }
  }
    return chatUsers;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          centerTitle: true,
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
          title: SizedBox(
            height: 30,
            width: 70,
            child: Image.asset("assets/images/logo.png"),
          ),
        ),
        body: Padding(
          padding: AppPaddings.defaultPadding,
          child: GetBuilder<ChatListController>(
                  init: ChatListController(),
                  builder: (controller) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: "Manage Clients",
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        AppPaddings.heightSpace20,
                        Expanded(
                          child: FutureBuilder(
                            future: getChatUsers(),
                            builder: (context, snapshot) {
                             if(snapshot.connectionState == ConnectionState.waiting){
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                             }else{
                               if(snapshot.data!.length > 0){
                                return ListView.builder(
                                  itemCount: snapshot.data?.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 15.0),
                                      child: ListTile(
                                        tileColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        onTap: () {
                                        Get.to(() => ChatScreen(
                                          chatroom: controller.getchatrooms[index],
                                          targetUser: snapshot.data![index],
                                          userModel: Get.find<UserController>().userModel.value,
                                        ));
                                        },
                                        contentPadding: const EdgeInsets.only(
                                          left: 5,
                                          right: 10,
                                        ),
                                        leading:  snapshot.data![index].profile != null ? CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            snapshot.data![index].profile.toString(),
                                          ), 
                                        ) : CircleAvatar(
                                          backgroundImage: AssetImage('assets/images/img1.png'),
                                        ),
                                        trailing: const Icon(
                                          Icons.keyboard_arrow_right_rounded,
                                        ),
                                        title: AppText(text: snapshot.data![index].firstname.toString() + " "+snapshot.data![index].lastname.toString()),
                                      ),
                                    );
                                  },
                                );
                               }else{
                                return Center(
                                  child: AppText(text: "No chats are avalaible"),
                                );
                               }
                             }
                            }
                          )
                          )
                      ],
                    );
                  })
        ),
      ),
    );
  }
}
