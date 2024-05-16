import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hypee_content_creator/controllers/completed_projects_controller.dart';
import 'package:hypee_content_creator/widgets/completed_projects_card.dart';
import 'package:hypee_content_creator/widgets/navbar.dart';

class completeProjects extends StatelessWidget {
  const completeProjects({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(
        init: CompleteProjectsController(),
        builder: (controller) {
          return FutureBuilder(
            future: controller.getProjectsList(),
            builder: (context,snapshot) {
              if(snapshot.connectionState==ConnectionState.waiting){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }else{
                var data = snapshot!.data;
                return Column(
        children: [
              Expanded(
                child:  ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context,index) {
                    return CompletedProjectsCard(projectId: data![index].projectId.toString(),ProjectStatus: "completed",);
                  }
                )                   
              )
        ],
      );
              }
            }
          );
        }, 
        ),
    bottomNavigationBar: Custom_navbar(), 
    );
  }
}