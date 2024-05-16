import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hypee_content_creator/constants/app_colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoBoxControlller extends GetxController{
   VideoPlayerController? videoController;
   ChewieController? chewie_Controller;
    List? thumbFile=[];
  Future<void> initializeVideo(String vid_player_path) async {
    // final url = await getDocId();

    // print(url);
 
      //videoController = VideoPlayerController.contentUri(Uri.parse(url));
      // print("vc1");
      // await Future.wait([videoController.initialize()]);
        final vid_url = vid_player_path;
    
    print("videoplayer");
    print(vid_url);
    // videoUrl.value = url;
    print(vid_url);
    // final vid_url=await getVideoUrl(url);
      videoController = VideoPlayerController.contentUri(Uri.parse(vid_url!));
      
      try {
  await Future.wait([videoController!.initialize()]);
} catch (e) {
  print("Video initialization error: $e");
  // Handle the error appropriately, e.g., show an error message to the user.
}
      chewie_Controller=ChewieController(
        videoPlayerController: videoController!,
        autoPlay: true,
        looping: true,
        aspectRatio: videoController?.value.aspectRatio,
        allowFullScreen: true,
        materialProgressColors: ChewieProgressColors(
        playedColor: AppColors.primaryColor,
        handleColor: AppColors.primaryColor,
          
        backgroundColor: Colors.grey,
        bufferedColor: Colors.grey.withOpacity(0.5),          
        ),
      placeholder: Container(
          color: Colors.black,
        ),
        
        autoInitialize: false 
      

      );

      update();    
  }
  @override
  void onClose() {
    videoController?.dispose();
    chewie_Controller!.dispose();
    super.onClose();
  }

   @override
  void onInit() {
    //videoController.initialize();
        super.onInit();
  }
 
  Future<String> generateThumbnail(Reference? ref)async{
  String url = await ref!.getDownloadURL();
  String thumbnailPath = (await getTemporaryDirectory()).path;
  
  // Create a unique file name by appending a timestamp
  String uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}.png';

  // Generate the thumbnail and save it with the unique file name
  String? thumbnailFilePath = await VideoThumbnail.thumbnailFile(
    video: url,
    thumbnailPath: thumbnailPath,
    imageFormat: ImageFormat.PNG,
  );

  // Construct the complete file paths for old and new names
  File thumbnailFileObj = File(thumbnailFilePath.toString());
  String newFilePath = thumbnailPath + '/' + uniqueFileName;
  print(newFilePath);
  // Rename the thumbnail file with the unique file name
  await thumbnailFileObj.rename(newFilePath);

  return newFilePath; // Return the new file path
}
}