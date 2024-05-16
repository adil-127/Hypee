import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:cross_file/cross_file.dart';
import 'package:hypee_content_creator/controllers/textbox_controller.dart';
import 'package:hypee_content_creator/views/dashboards/landscape_videoplayer.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hypee_content_creator/constants/app_colors.dart';
import 'package:hypee_content_creator/constants/app_paddings.dart';
import 'package:hypee_content_creator/controllers/upload_project_data_controller.dart';
import 'package:hypee_content_creator/views/chat_screen.dart';
import 'package:hypee_content_creator/widgets/buttons/app_button.dart';
import 'package:video_player/video_player.dart';
import '../../widgets/app_text.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';
class UploadFiles extends StatelessWidget {
 
  // const ProjectManagementDashboard({Key? key}) : super(key: key);
PlatformFile? picked_vid;
PlatformFile?picked_audio;
String? video_url;
int a=-1;
int b=0;
int? Vc_id;
  int? VE_id;
  int? project_id;
UploadFiles({this.project_id});
  // Stream<List<ListResult>> files = [];
  // FirebaseStorage _firebaseStrorage = FirebaseStorage.instance;
  // Stream<List<>> getFiles(){
  //   var ref = FirebaseStorage.instance.ref("b514d900-4b85-11ee-a3b8-b9df3ab43378/video");
  //   ref.listAll()
  // }
  @override
  Widget build(BuildContext context) {
    DeviceOrientation.portraitUp;
    return GetBuilder<UploadFilesController>(
            init: UploadFilesController(),
            builder: (controller){
             
    return SafeArea(
      child: 
      
      Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              onTap: () => Get.back(),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.arrow_back,
                ),
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          title: AppText(
            text: "  Dashboard ",
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        body: Padding(
          padding: AppPaddings.defaultPadding,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppPaddings.heightSpace30,
                AppText(
                  text: "Needs & wants",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                AppPaddings.heightSpace20,
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // AppText(text: "- Cut pauses with no talking"),
                        textbox(project_id!),
                        // AppPaddings.heightSpace5,
                        // AppText(text: "- Eliminate shadows"),
                        // AppPaddings.heightSpace5,
                        // AppText(text: "- Add sound effects to motions"),
                      ],
                    ),
                  ),
                ),
                AppPaddings.heightSpace30,
                AppText(
                  text: "Raw Footage",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                AppPaddings.heightSpace20,
                ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 110),

                  child:
                  Obx( () {
                    return 
                    ListView.builder(
                    scrollDirection: Axis.horizontal,
                    
                    itemCount: controller.thumb_file!.length,
                    itemBuilder: (BuildContext context, int index) {
                    
                      // print(a);
                      // print(File(controller.thumb_file![a-1]));
                      return InkWell(
                  
                   
                    child:
               
                     Container(
                     height: 110,
                     width: 130,
                     margin: const EdgeInsets.only(
                       right: 20,
                     ),
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(15),
                  
                     ),
                     child: Center(
                    child: 
                    
                    // controller.thumb_file?[a-1]!=null?
                                Stack(
                                  alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          
                          child: 
                          Image.file(File(controller.thumb_file![index]))),
                          
                        Positioned(
                        
                          child: InkWell (
                            onTap: () async{
                             await controller.initializeVideo(controller.video_url![index]);
                            Get.to(() => land_scape_video_player(chewie_Controller: controller.chewie_Controller!,));
                            },
                            child: SvgPicture.asset(
                          "assets/icons/play.svg",width: 25,
                        
                        ),)
                        
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: InkWell(
                          onTap: () {
                            controller.video_url!.removeAt(index);
                            controller.thumb_file!.removeAt(index);
                            a--;
                            controller.i=controller.i-1;
                          },
                          child: Icon(Icons.cancel, color: Colors.white,),
                        ),
                        ),
                      ],
                      )
                      // :Text("Select video",style: TextStyle(color:AppColors.primaryColor),)
                             
                      
                     ),
                      )
                   
                  );
                    },
                  );
                  }),
                   
                ),
                InkWell(
  onTap: () async {
    final pickedFiles = await pickFiles(); // Use a list to store multiple files
    if (pickedFiles != null && pickedFiles.isNotEmpty) {

      print("Files picked: ${pickedFiles.length}");
      
      for (var pickedFile in pickedFiles) {
        await controller.selectVideo(pickedFile);
       

      }
        await controller.generateThumbnail();

    }
  },
  child: Center(
    child: Icon(Icons.attach_file_outlined),
  ),
),









                AppPaddings.heightSpace30,
                AppText(
                  text: "Audio",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                AppPaddings.heightSpace20,

                ConstrainedBox(
               constraints: BoxConstraints(maxHeight: 110),
             
                  child:
                  Obx( () {
                    return 
                   ListView.builder(
                   
                  scrollDirection: Axis.horizontal,
                  
                  itemCount: controller.audio_url!.length,
                  itemBuilder: (BuildContext context, int index) {
                    print(b);
                    // print(File(controller.thumb_file![a-1]));
                    return InkWell(
                    //       onTap: () async{
                    //   picked_vid = await pickfiles();
                  
                    //   // controller.initialize_videoplayer();
                    //   controller.selectvideo(picked_vid);
                    //   controller.generateThumbnail();
                    // },    
                     
                  child:
                  // picked_vid==null?
                   Container(
                   height: 110,
                   width: 130,
                   margin: const EdgeInsets.only(
                     right: 20,
                   ),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(15),
                   ),
                   child: Center(
                  child: 
                  
                  // controller.audio_url?[b-1]!=null?
                      audio_player(index)
                    // :Text("Select video",style: TextStyle(color:AppColors.primaryColor),)
                           
                    
                   ),
                    )
                     
                    );
                  },
                    
                  );
                    }),
                ),

                      InkWell(
                  onTap: () async{
    final pickedAudio = await pickFiles(); // Use a list to store multiple files
                    
    if (pickedAudio != null && pickedAudio.isNotEmpty) {

      print("Files picked: ${pickedAudio.length}");
      
      for (var pickedFile in pickedAudio) {
        await controller.selectAudio(pickedFile);
       

      }

    }
  },
                  child: Center(
                    child: Icon(Icons.attach_file_outlined),
                  ),
                ),
                AppPaddings.heightSpace40,
                Center(
                  child: AppText(
                    text: "Save",
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                AppPaddings.heightSpace30,
                GetBuilder<UploadFilesController>(
                  init: UploadFilesController(),
                  builder: (controller) {
                    return CheckboxListTile(
                      activeColor: AppColors.primaryColor,
                      checkColor: Colors.white,
                      controlAffinity: ListTileControlAffinity.leading,
                      value: controller.currentValue,
                      onChanged: (value) {
                        controller.changeValue(value!);
                      },
                      title: AppText(text: "Mark the project as edited"),
                    );
                  },
                ),
                AppPaddings.heightSpace30,
                
                Obx(() {
                  return
                  controller.isUploading.value==false?
                  InkWell(
                  onTap: () {
                    controller.upload_vid_file(project_id);
                  },
                  child: AppButton(
                    text: "Upload Project Video",
                  ),
                ):CircularProgressIndicator();
                },),
                
                AppPaddings.heightSpace30,
                AppButton(
                  //onTap: () => Get.to(() => ChatScreen()),
                  borderColor: Colors.grey,
                  text: "Conversation Now",
                  icon: SvgPicture.asset(
                    "assets/icons/Chat.svg",
                    color: AppColors.primaryColor,
                    width: 20,
                  ),
                  textColor: AppColors.primaryColor,
                  buttonColor: AppColors.lightGrey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
            }
    );
  }

}
 Future<List<PlatformFile>?> pickFiles() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
   
  if (result != null && result.files.isNotEmpty) {
    
    return result.files;
  } else {
    return null;
  }
}





//  initialize_videoplayer(){
//     // if (_videoController!=null) {

//   _videoController= VideoPlayerController.file(File(vid!))
//   ..initialize().then((_){
//     _videoController!.play();
//     update();
//   },
//   );
  
//     // }
//     // else{
//     //   return null;
//     // }

// }

// Widget _videopreview(){
//   return GetBuilder<ProjectManagementController>(
//             init: ProjectManagementController(),
//             builder: (controller){
//               VideoPlayerController? vid=controller.vid_controller();
//                 if (vid!=null) {
//                     return AspectRatio(aspectRatio:vid.value.aspectRatio,
//                     child: VideoPlayer(vid),
//                     );
//                 }
//                 else{
//                      print("fail");
//                   return const CircularProgressIndicator();
                  
//                 }
//             }
//   );
// }

Widget audio_player(int index){
  return 
  GetBuilder<UploadFilesController>(init: UploadFilesController(), builder:(controller) {
    return Column(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          alignment: Alignment.center,
          children: [
            
              Container(
             height: 110,
             width: 130,
              child: Image.asset("assets/images/music.jpg",)),
              Obx(() {
        return CircleAvatar(
          radius: 20,
          
          child: Center(
            child: IconButton(onPressed:() async{
            if(controller.is_playing.value==true){
              controller.isPlayingFalse();

              await controller.audioPlayer.pause();
            }
            else{
              var a=Uri.parse(controller.audio_url![index] );
              controller.audioPlayer.setAudioSource(
              AudioSource.uri(a)
              );
                controller.isPlayingTrue();

                await controller.audioPlayer.play();          // controller.audioPlayer.play();
            }
          
              
            }, icon: Icon(controller.is_playing.isTrue? Icons.pause:Icons.play_arrow)),
          ),
        );
      })
            ],
        ),
      ), 
    ],
  );
  }, );
 
}

Widget textbox(int projectid) {
  return GetBuilder<BulletPointController>(
    init: BulletPointController(),
    builder: (controller) {
      return Container(
        height: 150,
        width: double.infinity,
          child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: controller.textController,
                    decoration: InputDecoration(
                      hintText: 'Enter text here',
                    ),
                    onSubmitted: controller.addBulletPoint,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => controller.addtextToDb(projectid)
                ),
              ],
            ),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.bulletPoints.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(controller.bulletPoints[index]),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

// class uploadBtn extends StatefulWidget {

//   int? project_id;
//   uploadBtn({this.project_id});
//   @override
//   State<uploadBtn> createState() => _uploadBtnState();
// }

// class _uploadBtnState extends State<uploadBtn> {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<UploadFilesController>(init:UploadFilesController() ,builder:(controller){
       
//        return 
//        InkWell(
//                   onTap: () {
//                     controller.upload_vid_file(widget.project_id);
//                   },
//                   child: AppButton(
//                     text: "Upload Project Video",
//                   ),
//                 );
//     });
//   }
// }