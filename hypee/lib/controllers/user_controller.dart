import 'package:get/get.dart';
import 'package:hypee_content_creator/models/UserModel.dart';

class UserController extends GetxController{
  Rx<UserModel> userModel = UserModel().obs;
}