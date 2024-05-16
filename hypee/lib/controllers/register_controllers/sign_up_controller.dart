import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';


class SignUpController extends GetxController {
  int selectedIndex = 0;
  String selectedCategory = 'Cat 1';
  // String? filePath;
  TextEditingController? video_duration;
  bool isLoading = false;
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  bool obsecuretext = true;
  String message = "";
  List<String> allCategories = [
    "Cat 1",
    "Cat 2",
    "Cat 3",
  ];
  Map<String, dynamic>? UserData; 
  bool isUpload = false;
  String filename = "";
  PlatformFile? profile_pic;
  // changeCat(value) {
  //   selectedCategory = value;
  //   update();
  // }

  List<String> selectedSoftwareType = [];

  List<String> allSoftwareTypes = [
    "Soft 1",
    "Soft 2",
    "Soft 3",
  ];
  selectProfilepic(PlatformFile? image){
    profile_pic = image;
    update();
  }
  changeSoftwareType(value) {
    selectedSoftwareType = value;
    update();
  }

  List<String> selectedSkillType = [];

  List<String> allSkillTypes = [
    "Skill 1",
    "Skill 2",
    "Skill 3",
  ];
  changeSkillType(value) {
    selectedSkillType = value;
    update();
  }

  String selectedVideoType = 'Type 1';
  List<String> allVideoTypes = [
    "Type 1",
    "Type 2",
    "Type 3",
  ];
  changeVideoType(value) {
    selectedVideoType = value;
    update();
  }

  changeIndex(int index) {
    selectedIndex = index;
    update();
  }

  // pickImage() async {
  //   var result = await FilePicker.platform.pickFiles(
  //     type: FileType.image,
  //   );
  //   if (result != null) {
  //     filePath = result.files.first.path;
  //     return filePath;
  //   }
  // }

  changefileName(String name){
       isUpload = true;
       filename = name;
       update();
  }
  Future<User?> signUp(Map<String, dynamic> user_credentials, PlatformFile? file,  PlatformFile? profile) async {
    //print("$user_credentials['email'] and $user_credentials['password']");
     try{
      isLoading = true;
      update();
       await FirebaseAuth.instance.createUserWithEmailAndPassword(email: user_credentials["email"], password: user_credentials["password"]);
       //print(FirebaseAuth.instance.currentUser!.uid.hashCode);
       var user = FirebaseAuth.instance.currentUser;
       int user_id = user!.uid.hashCode; 
       //print("abc");
       if(profile != null){
        var name = profile!.name;
        var path = "$user_id/profile/$name";
        var file_path = File(profile!.path!);
        var ref = FirebaseStorage.instance.ref().child(path);
        await ref.putFile(file_path);
        var profile_path = {"profile": path};
        user_credentials.addAll(profile_path);
       }
      if(file != null){
        var name = file!.name;
        var path = "$user_id/$name";
        var file_path = File(file!.path!);
        var ref = FirebaseStorage.instance.ref().child(path);
        await ref.putFile(file_path);
      }
      String token = await FirebaseMessaging.instance.getToken().toString();
      user_credentials.addAll({"pushToken":token});
      isLoading = false;
      update();
      postDetailsToFirestoreOfSignUp(user_credentials);
      return FirebaseAuth.instance.currentUser;
     }on FirebaseAuthException catch (e){
      isLoading = false;
      update();
     }
  }

  postDetailsToFirestoreOfSignUp(Map<String,dynamic> user_credentials) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = FirebaseAuth.instance.currentUser;
    var user_id = {"id": user!.uid.hashCode};
    user_credentials.addAll(user_id);
    CollectionReference ref = FirebaseFirestore.instance.collection('UsersData');
    ref.doc(user!.uid).set(user_credentials);
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
 
 Future<PlatformFile> pickfiles() async{
   final result = await FilePicker.platform.pickFiles();
   return result!.files.first;
 }
  Future<UserCredential> signInWithFacebook() async {
  LoginResult loginresult = await FacebookAuth.instance.login(permissions: ['email']);
  if(loginresult == LoginStatus.success){
    UserData = await FacebookAuth.instance.getUserData();
  }else{
     print(loginresult.message);
  }
  OAuthCredential oAuthCredential = FacebookAuthProvider.credential(loginresult.accessToken!.token);
  return await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
}
String? validateEmail(String value) {
    if (!GetUtils.isEmail(value)) {
      return "Provide valid Email";
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.length < 6) {
      return "Password must be of 6 characters";
    }
    return null;
  }
  String? validateDuration(value) {
    if (value == null ) {
      return "Please enter video duration";
    }
    return null;
  }
  var isValid;
  void checkSignup() {
    isValid = loginFormKey.currentState!.validate();
  }

   isShowPassword(bool show){
      obsecuretext = show;
      update();
    }
}
