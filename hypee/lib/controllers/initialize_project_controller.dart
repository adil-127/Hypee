import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:hypee_content_creator/models/UserModel.dart';
import 'package:uuid/uuid.dart';

class initialize_project_controller {
  UserModel Vc;
  UserModel VE;
  initialize_project_controller({required this.VE,required this.Vc});
  
  Future <int >initializeProject( )async{
    // path for aud and vid
     const uuid=Uuid();  
     String folder=uuid.v1();
     int folderid=folder.hashCode;
     final folder_ref = FirebaseStorage.instance.ref().child('projects/$folderid');


 final projectsCollection = FirebaseFirestore.instance.collection('projects');
      final projectDocument = projectsCollection.doc('$folder');
      final vid_folder_URL = 'projects/$folderid/videos';
      final audioPath = 'projects/$folderid/audios';

      await projectDocument.set({
        'projectId': folderid,
        "video Path":vid_folder_URL,
        "audio Path": audioPath,
         'VC':Vc.toMap(),
         'VE':VE.toMap(),
         'status': 'Pending',
      }

      );

      return folderid;
    
}

}