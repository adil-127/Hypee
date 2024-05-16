import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:hypee_content_creator/constants/app_colors.dart';
import 'package:hypee_content_creator/controllers/user_controller.dart';
import 'package:hypee_content_creator/models/ProjectModel.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http; 
import 'package:chewie/chewie.dart';
import 'package:video_thumbnail/video_thumbnail.dart';



class ProjectManagementController extends GetxController{
    bool currentValue = true;
  int selectedIndex = 0;
  late VideoPlayerController videoController;
  late RxString videoUrl = ''.obs;
  String? thumbnailFile;
  var currentUser = Get.find<UserController>();
  //   final audioPlayer=AudioPlayer();
  // final audioQuery =OnAudioQuery();
  // RxBool is_playing=false.obs;
  // Rx<Duration> duration=Duration.zero.obs;
  // Rx<Duration> position=Duration.zero.obs;
  
  final audioPlayer = AudioPlayer();
  final audioQuery = OnAudioQuery();
  final RxBool is_playing = false.obs;
  final Rx<Duration> duration = Duration.zero.obs;
  final Rx<Duration> position = Duration.zero.obs;
  int lastPlayedIndex = -1; // Keep track of the last played audio index.

  // Future<void> playAudio(int index) async {
  //   var a = Uri.parse(audioFiles![index]);

  //   if (is_playing.value && lastPlayedIndex == index) {
  //     // Pause the currently playing audio.
  //     await audioPlayer.pause();
  //     is_playing.value = false;
  //   } else {
  //     // Start or resume playback.
  //     if (lastPlayedIndex != index) {
  //       // If a different audio file is selected, set the new audio source.
  //       audioPlayer.setAudioSource(AudioSource.uri(a));
  //     }

  //     // Seek to the last played position or start from the beginning.
  //     await audioPlayer.seek(position.value);

  //     // Start or resume playback.
  //     await audioPlayer.play();
  //     is_playing.value = true;

  //     // Update the last played index.
  //     lastPlayedIndex = index;
  //   }
  // }
  isPlayingFalse(){
   is_playing.value=false;
   update();
}
isPlayingTrue(){
   is_playing.value=true;
   update();
}

  changeIndex(int index) {
    selectedIndex = index;
    update();
  }

  changeValue(bool val) {
    currentValue = val;
    update();
  }

 

  @override
   void onInit(){
    super.onInit();
  }

  @override
  void onReady(){
    super.onReady();
  }
  



Future<ListResult> getDocId(String path) async {
// var doc_id = await FirebaseFirestore.instance.collection("projects").where("projectId",isEqualTo: user_id).get();
// print("doccc_id");

final ref = FirebaseStorage.instance.ref(path);
 var getFiles =await ref.listAll();
 print(getFiles.items);
    return getFiles;
}









 DownloadFile()async{
   try {
     
   
    final snapshot = await FirebaseFirestore.instance.collection('projects').doc("0091a040-46b6-11ee-80bf-45ca90e4a293").get();
    
    if (snapshot.exists) {
      final videoData = snapshot.data();
      print("1");
      final videoUrl = videoData?['Video Path'];
      if (videoUrl != null) {
        print("2");
                 final ref = FirebaseStorage.instance.ref(videoUrl);
        final url = await ref.getDownloadURL();
          // final videoUri = Uri.parse(url);
          print(url);
          final temp_dir=await getTemporaryDirectory();
         
          print("3");
           final path="${temp_dir.path}/${ref.name}";
           await Dio().download(url,path);
                     print("4");

           if(url.contains(".mov")){
            
            await GallerySaver.saveVideo(path,toDcim:true );
           }
          print("4");
         
      }
    }
   }
catch (e) {
     print('Error downloading file: $e');
 
   }
}
bool isLoading = false;
String projectVideoPath = ""; 
String projectAudPath = "";
late ProjectModel currentProject; 

int? projectId;
Future<List<ProjectModel>> getProjectsList()async{
  List<ProjectModel> projectList = currentUser.userModel.value.role == "VC" ? await ProjectModel.getProjectsByQuery(status: "Pending",vc:currentUser.userModel.value.id) : await ProjectModel.getProjectsByQuery(status: "Pending",ve:currentUser.userModel.value.id);
  // print(projectList[0].videoPath);
  if(projectList.length > 0){
    projectVideoPath = projectList[0].videoPath;
  projectAudPath=projectList[0].audioPath;
  projectId = projectList[0].projectId;
  currentProject = projectList[0];
  }
  return projectList;
}



  final audioFiles = <String>[];
Future<List<String>> listAudioFiles() async {
  final storage = FirebaseStorage.instance;
  final tempDir = await getTemporaryDirectory();
  try {
    final ListResult result = await storage.ref(projectAudPath).listAll();

    for (final item in result.items) {
      final tempFilePath = '${tempDir.path}/${item.name}';
      await item.writeToFile(File(tempFilePath));
        audioFiles.add(tempFilePath);
     
    }
    print(audioFiles);
    return audioFiles;
  } catch (e) {
    print('Error listing audio files in Firebase Storage: $e');
    return [];
  }
}















List<String> needs=[];


  Future<List<String>> fetchNeedsData(int project) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("projects")
          .where('projectId', isEqualTo: project)
          .get();
          print("project ki id:");
          print(project);

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        final data = documentSnapshot.data() as Map<String, dynamic>;

        // Assuming "needs" is a List of Strings in the document
       needs = List<String>.from(data['needs']);
        print("needs ki list");
        print(needs);
        return needs;
      } else {
        return []; // Return an empty list if no documents are found
      }
    } catch (error) {
      print("Error fetching data: $error");
      throw error;
    }
  }

final TextEditingController textController = TextEditingController();
  final RxList<String> bulletPoints = <String>[].obs;

  Future addBulletPoint(String value) async{
 if (value != null && value.isNotEmpty) {
    bulletPoints.add('• $value'); 

    textController.clear(); 
    print(bulletPoints);
  }
  }
  Future addtextToDb(int project_id) async{
    int project=project_id;
  final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection("projects")
      .where('projectId', isEqualTo: project)
      .get();
      print(querySnapshot);
       final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
    final DocumentReference documentReference = documentSnapshot.reference;

     final CollectionReference revisionsCollection = documentReference.collection("revisions");
      final DocumentReference newRevisionDocument = revisionsCollection.doc();

      
         
         await newRevisionDocument.set(
          {
            "revision":bulletPoints
          }
         );
  }

ChangeStatus(int projectId)async{
  isLoading = true;
  update();
   int project=projectId;
   print("2");
  final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection("projects")
      .where('projectId', isEqualTo: project)
      .get();
      print(querySnapshot);
       final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
    final DocumentReference documentReference = documentSnapshot.reference;
  await documentReference.update({
    "status":"completed"
  });
  print("done");
  isLoading = false;
  update();
}

  @override
  void onClose() {
    textController.dispose();
    audioPlayer.dispose();

    super.onClose();
  }
}
 