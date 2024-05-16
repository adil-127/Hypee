import 'dart:io';
// import 'package:audioplayers/audioplayers.dart';
import 'package:chewie/chewie.dart';
import 'package:cross_file/cross_file.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hypee_content_creator/constants/app_colors.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:just_audio/just_audio.dart';

// import 'package:audioplayers/audioplayers.dart';
class UploadFilesController extends GetxController {
  bool currentValue = true;
  int selectedIndex = 0;
  int p=1;
  PlatformFile? picked_vid;
   PlatformFile? picked_audio;
VideoPlayerController? videoController;
  ChewieController? chewie_Controller;
  String? thumbnailFile;


  RxList? video_url=[].obs;
  RxList? audio_url=[].obs;
  RxList? thumb_file=[].obs;

  
  final audioPlayer=AudioPlayer();
  final audioQuery =OnAudioQuery();
  RxBool is_playing=false.obs;
  Rx<Duration> duration=Duration.zero.obs;
  Rx<Duration> position=Duration.zero.obs;
// var vid;
var vid_cont;
late String vid_url;

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

  






// // selecting video
//    selectvideo(PlatformFile? video){
    
//      picked_vid = video;
//     //print(picked_vid!.path);    
//     video_url!.add(picked_vid!.path);
//     update();
//   }
List<PlatformFile>? pickedVideos; // List to store selected videos
List<String> allowedVideoFormats = ['.mp4', '.avi', '.mov', '.mkv']; // List of allowed video formats

selectVideo(PlatformFile video) {
  pickedVideos ??= []; // Initialize the list if it's null
  
  // Get the file extension from the video path
  String fileExtension = video.path!.split('.').last.toLowerCase();
  
  // Check if the file extension is in the list of allowed formats
  if (allowedVideoFormats.contains('.' + fileExtension)) {
    pickedVideos!.add(video);
    video_url!.add(video.path);
    print("Picked file");
    print(video_url);
    update();
  } else {
    print("Invalid video format. Only the following formats are allowed: ${allowedVideoFormats.join(', ')}");
  }
}




List<PlatformFile>? pickedAudios; // List to store selected audio files
List<String> allowedAudioFormats = ['.mp3', '.wav', '.ogg']; // List of allowed audio formats

selectAudio(PlatformFile audio) {
  pickedAudios ??= []; // Initialize the list if it's null

  // Get the file extension from the audio path
  String fileExtension = audio.path!.split('.').last.toLowerCase();

  // Check if the file extension is in the list of allowed formats
  if (allowedAudioFormats.contains('.' + fileExtension)) {
    pickedAudios!.add(audio);
    audio_url!.add(audio.path);
    print("Picked audio");
    print(audio_url);
    update();
  } else {
    print("Invalid audio format. Only the following formats are allowed: ${allowedAudioFormats.join(', ')}");
  }
}

int i=0;

Future generateThumbnail()async{
  final appDir = await syspaths.getTemporaryDirectory();
  
   

    for(i;i<video_url!.length;i++){
     thumbnailFile= await VideoThumbnail.thumbnailFile(video:video_url![i],thumbnailPath: (await getTemporaryDirectory()).path,imageFormat: ImageFormat.PNG); 
     print("ppathh");
      print(thumbnailFile); 
      thumb_file!.add(thumbnailFile!);
      print("thumb lissst");
      print(thumb_file);
      thumbnailFile=null;
       update();  
    }
   
}


  Future<void> initializeVideo(String vid_player_path) async {
    // final vid_url = await picked_vid!.path;
    final vid_url = await vid_player_path;
    
    print("videoplayer");
    print(vid_url);
    // videoUrl.value = url;
    print(vid_url);
    // final vid_url=await getVideoUrl(url);
      videoController = VideoPlayerController.contentUri(Uri.parse(vid_url!));
      print("vc1");
      try {
        
      
      
      await Future.wait([videoController!.initialize()]); 
      chewie_Controller=ChewieController(
        
        videoPlayerController: videoController!,
        autoPlay: false,
        looping: false,
        progressIndicatorDelay: Duration(milliseconds: 1500),
        
        aspectRatio: videoController!.value.aspectRatio,
        allowFullScreen: true,
        
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.primaryColor,
          handleColor: Colors.deepPurple,
          backgroundColor: Colors.white,
          bufferedColor: Colors.grey,
        ),
        placeholder: Container(
          color: Colors.black,
        ),
        
        autoInitialize: false 

      );
      } 
      catch (e) {
        print("error$e");
      }
      
      update();   
  }
  















  Rx<bool> isUploading = false.obs;
  bool hasUploaded=false;



  Future upload_vid_file(  int? project_id)async{
    // path for aud and vid
    //  const uuid=Uuid();  
    //  String folder=uuid.v1();
    //  int folderid=folder.hashCode;
    try {
      isUploading==true;
      update();
    
     final folder_ref = FirebaseStorage.instance.ref().child('projects/$project_id');
var q=1;
 for (int i = 0; i < video_url!.length; i++) {
  
      var vid_path='projects/$project_id/videos/vid$i';
             var vid_file=File(video_url![i]);

          var vid_ref =await FirebaseStorage.instance.ref().child(vid_path);
              var vid_uploadTask=vid_ref.putFile(vid_file);

                                             }
                                             
for (int i = 0; i < audio_url!.length; i++) {
      final aud_path='projects/$project_id/audios/aud$i';
             final aud_file=File(audio_url![i]);


          final aud_ref = FirebaseStorage.instance.ref().child(aud_path);
              var aud_uploadTask=aud_ref.putFile(aud_file);
  }
 isUploading==false;
 
 update();
   }  
catch (e) {
  print("error: ");
      print(e);
    }


}









//   Future upload_vid_file(  int? Vc_id, int? VE_id)async{
//     // path for aud and vid
//      const uuid=Uuid();  
//      String folder=uuid.v1();
//      int folderid=folder.hashCode;
//      final folder_ref = FirebaseStorage.instance.ref().child('projects/$folderid');
// var q=1;
//  for (int i = 0; i < video_url!.length; i++) {
  
//       var vid_path='projects/$folderid/videos/vid$i';
//              var vid_file=File(video_url![i]);

//           var vid_ref =await FirebaseStorage.instance.ref().child(vid_path);
//               var vid_uploadTask=vid_ref.putFile(vid_file);

//                                              }
                                             
// for (int i = 0; i < audio_url!.length; i++) {
//       final aud_path='projects/$folderid/video/${audio_url![i]}';
//              final aud_file=File(video_url![i].path);


//           final aud_ref = FirebaseStorage.instance.ref().child(aud_path);
//               var aud_uploadTask=aud_ref.putFile(aud_file);
//   }

//  final projectsCollection = FirebaseFirestore.instance.collection('projects');
//       final projectDocument = projectsCollection.doc('$folderid');
//       var user_id = FirebaseAuth.instance.currentUser!.uid;
//       final vid_folder_URL = 'projects/$folderid/videos';

//       await projectDocument.set({
//         'projectId': folderid,
//         "video Path":vid_folder_URL,

//         //  'VC':user_id,
//         //  'VE':"FL3qOfXBi5cng6Zg6U27pIJpVnI2",
//          'VC':Vc_id,
//          'VE':VE_id,
        
//       });
    
// }











// delete this commented code
//   Future upload_vid_file()async{
//     // path for aud and vid
//      const uuid=Uuid();  
//      String folder=uuid.v1();
//      final folder_ref = FirebaseStorage.instance.ref().child('projects/$folder');
//     final vid_path='projects/$folder/video/${picked_vid!.name}';
//     final aud_path='projects/$folder/audio/${picked_audio!.name}';
//     // upload vid
//     final vid_file=File(picked_vid!.path!);
//     final vid_ref = FirebaseStorage.instance.ref().child(vid_path);
//     var vid_uploadTask=vid_ref.putFile(vid_file);

//     // upload aud
//     final aud_file=File(picked_vid!.path!);
//     final aud_ref = FirebaseStorage.instance.ref().child(aud_path);
//     var uploadTask=aud_ref.putFile(aud_file);

//     await vid_uploadTask.whenComplete (() async {
//       final folder_URL = await folder_ref.fullPath;
//       final vid_Url = await vid_ref.fullPath;
//       final audio_Url = await aud_ref.fullPath;
      
//       final projectsCollection = FirebaseFirestore.instance.collection('projects');
//       final projectDocument = projectsCollection.doc('$folder');
//       var user_id = FirebaseAuth.instance.currentUser!.uid;
      
//       await projectDocument.set({
//         'projectId': folder,
//         'projectPath': folder_URL,
//         'Video Path':vid_Url,
//         'Audio Path':audio_Url,
//          'VC':user_id,
//          'VE':"FL3qOfXBi5cng6Zg6U27pIJpVnI2",
//       });
//     p++;
  
//   }
//     );    
// }

  @override
  void onClose() {
    videoController?.dispose();
    chewie_Controller?.dispose();
    audioPlayer.dispose();
    super.onClose();
  }

}
