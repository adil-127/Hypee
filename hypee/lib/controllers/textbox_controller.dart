import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class BulletPointController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final RxList<String> bulletPoints = <String>[].obs;

  Future addBulletPoint(String value) async{
 if (value != null && value.isNotEmpty) {
    bulletPoints.add('• $value'); 

    textController.clear(); 
    print(bulletPoints);
  }
  }
  Future addtextToDb(int project_id) async{
    int project=project_id;
  final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection("projects")
      .where('projectId', isEqualTo: project)
      .get();
      print(querySnapshot);
       final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
    final DocumentReference documentReference = documentSnapshot.reference;

         
         await documentReference.update(
          {
            "needs":bulletPoints
          }
         );
        
    
 
  }


  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}