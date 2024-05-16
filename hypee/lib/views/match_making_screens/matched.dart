import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hypee_content_creator/models/UserModel.dart';
import 'package:hypee_content_creator/views/buy_screen.dart';
import 'package:hypee_content_creator/views/dashboards/upload_project_files.dart';
import 'package:hypee_content_creator/views/profile_screens/editor_profile.dart';
import 'package:hypee_content_creator/widgets/buttons/app_button.dart';
import 'package:hypee_content_creator/widgets/gigs.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_paddings.dart';
import '../../widgets/app_text.dart';
import '../ChatList.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/navbar.dart';
import '../../controllers/navbar_controller.dart';
 double x=2;
class Matched extends StatelessWidget {
  const Matched({Key? key}) : super(key: key);

  Future<List<UserModel>> getUsersByRole(String role) async{
    var getlistings = await FirebaseFirestore.instance.collection("UsersData").where("role",isEqualTo: role).get();
    print(getlistings.docs.toList());
    var futureusers = await getlistings.docs.map((document)async{
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      //print(data['profile']);
      FirebaseStorage ref = FirebaseStorage.instance;
      String filepath = data['profile'];
      var pathRef = await ref.ref(filepath);
      var downloadUrl = await pathRef.getDownloadURL();
      data['profile'] = downloadUrl.toString();
      Map<String,dynamic>? additionalFields = {
        "additionalFields": {
          "skillType":data['skillType'], 
          "softType":data['softType']
        }
      };
      data.addAll(additionalFields);
      UserModel user = UserModel.fromMap(data);
      print(user.additionalFields);
      return user;
    }).toList();
    List<UserModel> users = await Future.wait(futureusers);
    print(users);
    return users;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            text: "Matched",
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
          child: Column(
            children: [
                  AppPaddings.heightSpace30,
              AppText(
                text: "We have matched you with ",
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              AppPaddings.heightSpace10,
              SizedBox(
                height: 30,
                width: 120,
                child: Image.asset("assets/images/logo.png"),
              ),
              AppPaddings.heightSpace30,
              Expanded(
                child: FutureBuilder(
                  future: getUsersByRole("VE"),
                  builder: (context, snapshot) {
                    var data = snapshot.data;
                   if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                   }else{
                     return ListView.builder(
                      itemCount: snapshot.data!.length, 
                      itemBuilder: (context, index) {
                        //print(data![index].profile.toString());
                        return InkWell(
                           splashColor: AppColors.primaryColor,
                  onTap: () {
                   Get.to(BuyScreen(matched_user: data[index],));
                  },
                          child: gigs(title: data![index].firstname.toString() + ' ' + data[index].lastname.toString(),img: data[index].profile.toString() ?? "",price: 4,rating: 4,text: "I make good editing", uid: data[index].id,));
                      },                     
                    );
                   }
                  }
                ),
              )
            ],
          ),
        ),  
        bottomNavigationBar: Custom_navbar(),
      )
    );
  }
}
