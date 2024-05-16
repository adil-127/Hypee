import 'package:get/get.dart';
import 'package:hypee_content_creator/controllers/user_controller.dart';
import 'package:hypee_content_creator/models/ProjectModel.dart';
//import 'package:hypee_content_creator/models/completed_project.dart';

class CompleteProjectsController extends GetxController{
  var currentUser = Get.find<UserController>();
Future<List<ProjectModel>> getProjectsList()async{
  List<ProjectModel> projectList = currentUser.userModel.value.role == "VC" ? await ProjectModel.getProjectsByQuery(status: "completed",vc:currentUser.userModel.value.id) : await ProjectModel.getProjectsByQuery(status: "completed",ve:currentUser.userModel.value.id);
  //print(projectList[0].videoPath);
  return projectList;
}
}