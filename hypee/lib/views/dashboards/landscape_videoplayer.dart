import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:hypee_content_creator/controllers/creator_management.dart';
import 'package:hypee_content_creator/controllers/upload_project_data_controller.dart';
import 'package:video_player/video_player.dart';

class land_scape_video_player extends StatelessWidget {
  // const land_scape_video_player({super.key});

   late ChewieController chewie_Controller;
  land_scape_video_player({required this.chewie_Controller});
  @override
  Widget build(BuildContext context) {
    // return GetBuilder<ProjectManagementController>(
      // init:ProjectManagementController()
      //  ,builder:(controller){
        // setLandScape();  
        // controller.initializeVideo();
        return SafeArea(
          child: Scaffold(
            body: 
            // controller.chewie_Controller!=null && 
            // controller.chewie_Controller!.videoPlayerController.value.isInitialized?
            chewie_Controller!=null &&chewie_Controller.videoPlayerController.value.isInitialized?
                      Chewie(  
                        // controller: controller.chewie_Controller!
                        controller: chewie_Controller
                      ):
                      CircularProgressIndicator(),
                    
          ),
  
        );

       } 

      // );
  
  
}

// Future setLandScape()async{
//     await SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//   }


    // picked_vid = await pickfiles();
                    
    //                 // controller.initialize_videoplayer();
    //                 controller.selectvideo(picked_vid);
    //                 controller.generateThumbnail();