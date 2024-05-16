import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hypee_content_creator/controllers/user_controller.dart';
import 'package:hypee_content_creator/models/ChatRoomModel.dart';
import 'package:hypee_content_creator/models/UserModel.dart';

class ChatListController extends GetxController {
  List<String> clientsName = [
    "Emilia",
    "Valentina Elena ",
    "Alexander 	",
    "Benjamin",
    "Marvin Mckinney",
    "Annie Merry",
    "Henry",
  ];
  List<String> clientsPics = [
    "https://images.unsplash.com/photo-1580489944761-15a19d654956?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=461&q=80",
    "https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1542596768-5d1d21f1cf98?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1623184663110-89ba5b565eb6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=812&q=80",
  ];
  UserController currentUser = Get.find<UserController>();
  List<ChatRoomModel> getchatrooms = [];
  Future<List<UserModel>> getChatUsers()async{
    int? currentUserId = Get.find<UserController>().userModel.value.id;
    var chatrooms = await FirebaseFirestore.instance.collection("chatrooms").where("participants.$currentUserId",isEqualTo: true).get();
    getchatrooms = chatrooms.docs.map((document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
     ChatRoomModel chatRoom = ChatRoomModel.fromMap(data);
      return chatRoom;
    }).toList();
     List<UserModel> chatUsers = [];
    for(ChatRoomModel chatroom in getchatrooms){
       //print(chatroom.chatroomid);
      chatroom.participants!.forEach((key, value)async{ 
        if(key != currentUser.userModel.value.id.toString()){
          //print(int.parse(key));
          var getUser = await FirebaseFirestore.instance.collection("UsersData").where("id", isEqualTo: int.parse(key)).get();
          UserModel user = UserModel.fromMap(getUser.docs.first.data() as Map<String,dynamic>);
           //print(user.firstname);
          chatUsers.add(user);
        }
      });
    }
    print(chatUsers);
    return chatUsers;
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getChatUsers();
  }
}
