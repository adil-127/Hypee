import 'package:firebase_auth/firebase_auth.dart';

class CurrentUser{
  Future<User?> getCurrUser() async{
    return await FirebaseAuth.instance.currentUser;
  } 
}