import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hypee_content_creator/constants/app_colors.dart';
import 'package:hypee_content_creator/controllers/videobox_controller.dart';

import '../views/dashboards/landscape_videoplayer.dart';

class VideoBox extends StatelessWidget {
  Reference? ref;
  VideoBox({super.key, this.ref});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: VideoBoxControlller(),
      builder: (controller) {
        return FutureBuilder(
          future: controller.generateThumbnail(ref),
          builder: (context,snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Container(
                width: 130,
                height: 110,
                color: Colors.white54,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }else{
              return Container(
                                height: 110,
                                width: 130,
                                margin: const EdgeInsets.only(
                                  right: 20,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  // child: SvgPicture.asset(
                                  //   "assets/icons/play.svg",
                                  //   width: 26,
                                  // ),
                                  
                                  child: 
                        //           Obx(() {
                        //             // VideoPlayerController? vid = controller.videoController;
                        //             controller.initializeVideo();
                        // return controller.videoController!.value.isInitialized
                        //   ? AspectRatio(
                        //     aspectRatio: controller.videoController!.value.aspectRatio,
                        //     child: VideoPlayer(controller.videoController!),
                    // const ProjectManagementDashboard({Key? key}) : super(key: key);      //  )
                        //   : CircularProgressIndicator();
                        //           }
                        //           ),


                              // controller.chewie_Controller!=null && controller.chewie_Controller!.videoPlayerController.value.isInitialized?
                              // Chewie(controller: controller.chewie_Controller!
                              // ):
                              // CircularProgressIndicator()
                              
                             
                            Stack(
                  children: [
                    Image.file(File(snapshot.data.toString())),
                    Positioned(
                      
                      bottom: 25,
                      left: 50,
                      right: 50,
                      child: InkWell(
                        onTap: () async{
                          String url = await ref!.getDownloadURL();
                          //print(url);
                             await controller.initializeVideo(url);
                        Get.to(land_scape_video_player(chewie_Controller: controller.chewie_Controller!,));
                        },
                        child: Icon(Icons.play_arrow,color: Colors.white,))
                    
                    )
                  ],)//:CircularProgressIndicator(color: AppColors.primaryColor,),
                              
                                ),
                              );
            }
          }
        );
      }
    );
  }
}