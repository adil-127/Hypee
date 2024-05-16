import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hypee_content_creator/constants/api_constaints.dart';
import 'package:hypee_content_creator/controllers/project_management_controller.dart';
import 'package:hypee_content_creator/controllers/user_controller.dart';
import 'package:hypee_content_creator/models/ProjectModel.dart';
import 'package:hypee_content_creator/views/chat_screen.dart';
import 'package:hypee_content_creator/views/complete_project.dart';
import 'package:hypee_content_creator/views/dashboards/landscape_videoplayer.dart';
import 'package:hypee_content_creator/views/dashboards/upload_project_files.dart';
import 'package:hypee_content_creator/widgets/videoplayer.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_paddings.dart';
import '../../controllers/upload_project_data_controller.dart';
import '../../widgets/app_text.dart';
import '../../widgets/buttons/app_button.dart';
import 'package:http/http.dart' as http;

class ProjectManagementDashboard extends StatelessWidget {
String? a;  

  // const ProjectManagementDashboard({Key? key}) : super(key: key);
 var currentUser = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectManagementController>(
      init: ProjectManagementController(),
      builder:  (controller){
    return controller.isLoading == false ? FutureBuilder<List<ProjectModel>>(
      future: controller.getProjectsList(),
      builder: (context,snapshot) {
       if(snapshot.connectionState == ConnectionState.waiting){
         return Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
          child: CircularProgressIndicator(),
         ),
          ),
         );
       }else{
        var data = snapshot.data;
        print(snapshot.data!.length);
         return snapshot.data!.isNotEmpty ? Scaffold(
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
                   AppText(
                     text: "Folders",
                     fontSize: 18,
                     fontWeight: FontWeight.w600,
                   ),
                   AppPaddings.heightSpace15,
                   Container(
                           width: MediaQuery.of(context).size.width,
                           height: 200,
                           child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                             itemCount: snapshot.data!.length,
                             itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: index == controller.selectedIndex
                                      ? AppColors.primaryColor
                                      : Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 175,
                                      width:
                                          MediaQuery.of(context).size.width * 0.4,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: const DecorationImage(
                                          image: AssetImage(
                                              "assets/images/sampleimg.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: AppText(
                                        text: "Project #"+data![index].projectId.toString(),
                                        color: index == controller.selectedIndex
                                            ? Colors.white
                                            : AppColors.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                             },
                           ),
                         ),
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
                          // FutureBuilder(
                          //   future: controller.fetchNeedsData(controller.projectId!),
                          
                          //   builder: (BuildContext context, AsyncSnapshot snapshot) {
                          //     if (snapshot.connectionState == ConnectionState.waiting) {
                          //    return CircularProgressIndicator(); } 
													// 	else if (snapshot.hasError) {
                          //    return Text('Error: ${snapshot.error}');}
		                      //   else if (!snapshot.hasData || snapshot.data.isEmpty) {
                          //   return Text('No data available');}
		                      //    else {
													// 		print("needs ki length");
													// 		print(controller.needs.length);
                          //     return }
                          //   },
                          // ),
                          Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                                child: controller.currentProject.needs == null ? AppText(text: "No need are defined yet") : ListView.builder(
                                 itemCount: controller.currentProject.needs.length,
                                 itemBuilder: (context, index) {
                                  print(controller.needs.length);
                                   return ListTile(
                                     title: Text(controller.currentProject.needs[index],style: TextStyle(fontSize: 17,),),
                                   );
                                 },
                                   ),
                              ),
                            //  
                         ],
                       ),
                     ),
                   ),
                   
                   AppPaddings.heightSpace30,
                   
                   FutureBuilder(future: controller.getDocId(controller.projectVideoPath), builder: (context,snapshot){
                     if(snapshot.connectionState == ConnectionState.waiting){
                       return CircularProgressIndicator();
                     }else{
                       return Column(
                         children: [
                           AppText(
                     text: "Raw Footage",
                     fontSize: 18,
                     fontWeight: FontWeight.w600,
                   ),
                   AppPaddings.heightSpace20,
                           Container(
                       // width: MediaQuery.of(context).size.width,
                       height: 110,
                       child: ListView.builder(
                         scrollDirection: Axis.horizontal,
                         itemCount: snapshot.data!.items.length,
                         itemBuilder: (context, index) {
                           print(snapshot.data!.items[index].name);
                           return VideoBox(ref: snapshot.data!.items[index]);
                         },
                       ),
                     ),
                     Center(
                     child: InkWell(
                       onTap: () {
                         controller.DownloadFile();
                       },
                       child: Icon(Icons.download)),
                   ),
                   AppText(
                     text: "Audio",
                     fontSize: 18,
                     fontWeight: FontWeight.w600,
                   ),
                   AppPaddings.heightSpace20,
                   Container(
                    height: 110,
                     child: FutureBuilder(
                       future: controller.listAudioFiles(),
                                 
                       builder: (BuildContext context, AsyncSnapshot snapshot) {
                        
                        if(snapshot.connectionState == ConnectionState.waiting){
                       return Center(
                         child: Container(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator()),
                       );
                     }else{
                         return ListView.builder(
                           itemCount: controller.audioFiles.length,
                           scrollDirection: Axis.horizontal,

                           
                           itemBuilder: (BuildContext context, int index) {
                          print(controller.audioFiles[index]);
                             return Padding(
                               padding: const EdgeInsets.only(left: 20),
                               child: AudioPlayer(index: index),
                             );
                           },
                         );
                         }
                       },
                     ),
                   ),
                         ],
                       ); 
                     }
                   }),
                   AppPaddings.heightSpace30,
                   AppText(
                     text: "Upload the Footage, Raw Text, Audio",
                     fontSize: 18,
                     fontWeight: FontWeight.w600,
                   ),
                   AppPaddings.heightSpace30,// Add bullet point
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
                   AppPaddings.heightSpace30,
                    currentUser.userModel.value.role=="VC" ?
                   Column(

                    children: [
                         AppPaddings.heightSpace30,
                   AppButton(
										onTap: () {
										  showDialog(context: context,
											 builder:(context)=>const CustomDialogWidget(),);
										},
                     text: "Mark Project To be Revised",
                     textColor: AppColors.primaryColor,
                     buttonColor: AppColors.lightGrey,
                   ),
                   AppPaddings.heightSpace30,
                
                   InkWell(
                     onTap: ()async{
                         var creatorName = controller.currentProject.vc.firstname.toString() + " " + controller.currentProject.vc.lastname.toString();
                         controller.ChangeStatus(controller.projectId!);
                         final apiUrl = Uri.parse('https://fcm.googleapis.com/fcm/send');

  // Define the request headers (if needed)
  final headers = {
    'Content-Type': 'application/json',
    'Authorization' : 'key=$authorizationtoken'
    // Add any other headers if required
  };

  // Define the request body
  final requestBody = {
    "registration_ids": [
      controller.currentProject.ve.pushToken
    ],
    "notification": {
      "body": "$creatorName marked project as completed.",
      "title": "Completed",
      "android_channel_id": "high_importance_channel",
      "sound": false
    }
  };

  // Send the POST request
  final response = await http.post(
    apiUrl,
    headers: headers,
    body: jsonEncode(requestBody),
  );

  // Check the response status
  if (response.statusCode == 200) {
    await Get.to(()=>ProjectManagementDashboard());
    print('Response data: ${response.body}');
    // You can parse and handle the response data here
  } else {
    print('Error: ${response.statusCode}');
    print('Error message: ${response.body}');
    // Handle the error response here
  }
                        Get.to(()=> completeProjects());
                    },
                     child: AppButton(
                       text: "Mark as Completed",
                     ),
                   ),
                    AppPaddings.heightSpace30,
                    ],
                   ): Text(""),
                   AppPaddings.heightSpace30,
                   InkWell(
                     onTap: () {
                      Get.to(()=>UploadFiles(project_id: controller.projectId,));
                    },
                     child: AppButton(
                       text: "Upload Project Video",
                     ),
                   ),
                 ],
               ),
             ),
           ),
         ) : Scaffold(
          body: Center(
            child: AppText(text: "No projects is started yet."),
          ),
         );
       }
      }
    ) : Scaffold(
      body: Center(
        child: CircularProgressIndicator()
        ),
    );
    }
      );
  }
}

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










// Widget _videopreview() {
//   return GetBuilder<ProjectManagementController>(
//     init: ProjectManagementController(),
//     builder: (controller) {
//     VideoPlayerController? vid = controller.videoController;
//       controller.onInit;
//       if (vid != null && vid.value.isInitialized) {
//         return Stack(
//           children: [
//             AspectRatio(
//               aspectRatio: vid.value.aspectRatio,
//               child: VideoPlayer(vid),
//             ),
//             Positioned(
              
//               bottom: 25,
//               left: 50,
//               right: 50,
//               child: InkWell(
//                 onTap: () {
//                   vid.value.isPlaying?vid.pause():vid.play();
//                 },
//                 child: Icon(Icons.play_arrow,color: Colors.white,))
            
//             )
//           ],
//         );
//       } else {
//         return const CircularProgressIndicator();
//       }
//     },
//   );
// }












// Widget _videopreview() {
//   return GetBuilder<ProjectManagementController>(
//     init: ProjectManagementController(),
//     builder: (controller) {
//       return FutureBuilder (future: controller.initializeVideo(), 
      
//      builder: (BuildContext context, AsyncSnapshot<VideoPlayerController> snapshot){
//       // if (snapshot.connectionState == ConnectionState.waiting) {
//       //         return CircularProgressIndicator(); // Display a loading indicator while onInit is running.
//       //       } else if (snapshot.hasError) {
//       //         return Text('Error: ${snapshot.error}');
//       //       }
//       //       else{
//         if(snapshot.hasError)
//         {
//           return Text('Error: ${snapshot.error}');
//         }
//         else{
//     VideoPlayerController vid = controller.videoController;
//       ChewieController? _chewieController;
//       print("vid");
//     print(vid);
//     _chewieController=ChewieController(
      
//       videoPlayerController:vid,
//       aspectRatio: 16/9,
      
//     );
//      print("vc2");
//       if (vid != null && vid.value.isInitialized) {
//         return AspectRatio(aspectRatio: 16/9,
//         child: Chewie(controller: _chewieController),
//         );
//       } else {
//         return Text("data");
//       }
//       }
//       },
//       );
//     },
//   );
// }

// Widget textbox(int projectid) {
//   // return GetBuilder<BulletPointController>(
//   //   init: BulletPointController(),
//   //   builder: (controller) {
//       return Container(
//         height: 150,
//         width: double.infinity,
//           child: Column(
//           children: [
//             Expanded(
//               child: Obx(
//                 () => ListView.builder(
//                   itemCount: controller.bulletPoints.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text(controller.bulletPoints[index]),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//   //   },
//   // );
// }
class CustomDialogWidget extends StatelessWidget {
	const CustomDialogWidget({super.key});

	@override
	Widget build(BuildContext context) {
		return  GestureDetector(
			onTap: () {
			         Future.delayed(Duration(microseconds: 1000), () {
          Navigator.of(context).pop();
        });
			},
					child: Stack(
								children: [ Container(
						color: Colors.black.withOpacity(0.7), 
						width: double.infinity,
						height: double.infinity,
					),
									Dialog(
										shape: RoundedRectangleBorder(
									borderRadius: BorderRadius.circular(16.0),),
										child: Container(
									decoration: BoxDecoration(
												color: AppColors.lightGrey,
												borderRadius: BorderRadius.circular(15),
					
											),
											child:GetBuilder<ProjectManagementController>(
						init: ProjectManagementController(),
						builder: (controller) {
							return Container(
									height: 200,
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
														onPressed: () => controller.addtextToDb(controller.projectId!)
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
					),
										),
									),
								],
							),
				);
	}
}
class AudioPlayer extends StatefulWidget {
  int? index;
AudioPlayer({this.index});
  @override
  State<AudioPlayer> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  bool isPlaying = false; 
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectManagementController>(init: ProjectManagementController(), builder:(controller) {
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
              // Obx(() {
         CircleAvatar(
          radius: 20,
          
          child: Center(
            child: IconButton(onPressed:() async{
            if(isPlaying==true){
              print("pause");
              setState(() {
                isPlaying=false;
              });

              await controller.audioPlayer.pause();
            }
            else{
               setState(() {
                 isPlaying=true;
               });

              var a=Uri.parse(controller.audioFiles![widget.index!] );
              controller.audioPlayer.setAudioSource(
              AudioSource.uri(a)
              );
                await controller.audioPlayer.play();          // controller.audioPlayer.play();
            }
            // await controller.playAudio(index);
              
            }, icon: Icon(isPlaying==true? Icons.pause:Icons.play_arrow)),
          ),
        )
      // })
            ],
        ),
      ), 
    ],
  );
  }, );
 
  }
}