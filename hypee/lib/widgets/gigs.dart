import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hypee_content_creator/views/buy_screen.dart';

import '../constants/app_colors.dart';
import 'app_text.dart';
double x =0;
class gigs extends StatelessWidget {
  
  String title="";
  String text="";
  int? price=0;
  int?rating=0;
  int? uid;
  String  img;

  gigs({ Key? key,this.text="",this.img="",this.price,this.rating,this.title="", this.uid}): super(key: key);

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
                    // color: Colors.red,
                    child: AppText(
                      text: (text),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                    ),
      
                  Container(
                    height: 25,
                   width: 160,
              
                    //color: Colors.pink,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                               Icon(Icons.star,color: AppColors.primaryColor,),
                              Text(rating.toString()),
                            ],
                          )
                          ),
                    //    AppText(
                    //   text: "From",
                    //   fontSize: 13,
                    //   fontWeight: FontWeight.w400,
                    //   color: AppColors.primaryColor,
                    // ),
                    //   AppText(
                    //     text: (price.toString()),
                    //     fontSize: 13,
                    //     fontWeight: FontWeight.w400,
                    //       color: AppColors.primaryColor,
                    //   ),
                      Icon(Icons.favorite,color:AppColors.primaryColor,),
                      ],
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