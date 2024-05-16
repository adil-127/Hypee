import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:hypee_content_creator/controllers/user_controller.dart';
import 'package:hypee_content_creator/models/UserModel.dart';

class EditorProfileController extends GetxController {
  PlatformFile? profile_pic;
  UserModel currentUser = Get.find<UserController>().userModel.value;
  List<String> settingsList = [
    "Account Information",
    "Manage Clients",
    "Link Payment Info",
    "Manage Projects",
    "Log Out",
  ];
   selectProfilepic(PlatformFile? image){
    profile_pic = image;
    update();
  }
  bool isLoading = false;
  changeprofilePic(PlatformFile? profile, UserModel user)async{
    isLoading=true;
    update();
    var ref = FirebaseStorage.instance.refFromURL(user.profile.toString());
    var result = await ref.delete();
    String newPath = user.id.toString() + "/profile/" + profile!.name;
     var file_path = File(profile!.path!);
    var newRef = await FirebaseStorage.instance.ref().child(newPath);
    await newRef.putFile(file_path);
    await FirebaseFirestore.instance.collection("UsersData").doc(FirebaseAuth.instance.currentUser!.uid).update({
      "profile": newPath
    });
    currentUser.profile = await newRef.getDownloadURL();
     isLoading= false;
    update();
  }
  String message = "";
  signOut()async{
    try{
       await FirebaseAuth.instance.signOut();
    }catch(e){
      print("Error signing out: $e");
    }
  }
}
