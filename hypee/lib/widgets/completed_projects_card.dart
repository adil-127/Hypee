import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hypee_content_creator/views/buy_screen.dart';

import '../constants/app_colors.dart';
import 'app_text.dart';
double x =0;
class CompletedProjectsCard extends StatelessWidget {
  
  String title="";
  String projectId="";
  String ProjectStatus="";
  int? uid;
  String  img;

  CompletedProjectsCard({ Key? key,this.projectId="",this.img="",this.ProjectStatus=""}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(20.0), // Set the desired radius here
      child: Card(
        shadowColor: Colors.purple[700],
      elevation: x,
      child: Container(
        height: 100,
        width: 350,
        child: Row(
          children: [
            Container(
              height: 100,
              width: 150,
              child: img == "" ? Image.asset("assets/images/img1.png") : Image.network(img),
              ),
              Container(
                height: 90,
                width: 200,
                // color: Colors.amber,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center ,
                  children: [
                  Container(
                    width: 160,
                          // color: Colors.blueAccent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                        
                          width: 160,
                          // color: Colors.blueAccent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(text: title,color: Colors.black,fontSize:12,fontWeight: FontWeight.w700,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                 
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 25,
                   width: 160,
                   
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AppText(
                          text: "ProjectId:",
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                         AppText(
                          text: projectId,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    ),
      
                  Container(
                    height: 25,
                   width: 160,
              
                    //color: Colors.pink,
                    child: Container(
                    
                      width: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                       
                            AppText(
                      text: "status:",
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                     AppText(
                      text: ProjectStatus,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),

                          // Text("status:"),
                          // Text(ProjectStatus)
                        ],
                      )
                      ),
                  ),
                  ],
                ),
              ),
          ],
        ),
      
      ),
                ),
    );
  }
}