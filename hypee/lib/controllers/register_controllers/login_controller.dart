

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hypee_content_creator/controllers/user_controller.dart';
import 'package:hypee_content_creator/models/UserModel.dart';
import 'package:hypee_content_creator/views/match_making_screens/matching.dart';
import 'package:hypee_content_creator/views/profile_screens/account_info.dart';
import 'package:hypee_content_creator/views/profile_screens/editor_profile.dart';
import 'package:hypee_content_creator/views/register_screens/login.dart';

class LoginController extends GetxController {
  int selectedIndex = 0;
  bool obsecuretext = true;
  String message = "";
  bool isLoading = false;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
  UserController userController = Get.find<UserController>();
  changeIndex(int index) {
    selectedIndex = index;
    update();
  }
  
  Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

Future<String?> signIn(String email, String password) async {
      isLoading = true;
      update();
      try {
      print(email);
      print(password);
      var user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
     try {
   var token = await FirebaseMessaging.instance.getToken();
  var userDoc = await FirebaseFirestore.instance.collection("UsersData").doc(user.user!.uid).get();

  if (userDoc.exists) {
    await FirebaseFirestore.instance.collection("UsersData").doc(user.user!.uid).update(
      {"pushToken": token}
    );
  } else {
     message = "User does not exist";
    isLoading = false;
        update();
        Get.to(()=>Login());
        return message;
  }
} catch (e) {
  // Handle other potential exceptions
}      
       isLoading = false;
       route();
        return "Logged-in Successfully";
      } on FirebaseAuthException catch (e) {
        isLoading = false;
        update();
        Get.to(()=>Login());
        return e.message;
      }
  }

  route()async{
    var user_id = FirebaseAuth.instance.currentUser!.uid;
      var kk = await FirebaseFirestore.instance.collection("UsersData").doc(user_id).get();
      if(kk.exists){
        var data = kk.data() as Map<String,dynamic>;
        if(data["role"]=="VE"){
          Map<String,dynamic>? additionalFields = {
        "additionalFields": {
          "skillType":data['skillType'], 
          "softType":data['softType']
        }
      };
      data.addAll(additionalFields);
        }
        if(data['profile'] == null){
          data['profile'] = null;
        }else{
          String profile = data['profile'];
          var ref = await FirebaseStorage.instance.ref(profile);
          data['profile'] = await ref.getDownloadURL();
        }
        userController.userModel.value = UserModel.fromMap(data);
        if(userController.userModel.value != null){
          if(userController.userModel.value.role == "VC"){
            Get.to(()=>Matching());
          }else{
            Get.to(()=>EditorProfile());
          }
        }
      }
  }
  isShowPassword(bool show){
      obsecuretext = show;
      update();
    }
}
