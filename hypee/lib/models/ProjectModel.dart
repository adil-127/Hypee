import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hypee_content_creator/models/UserModel.dart';

class ProjectModel {
 // You can replace 'id' with the actual field name if it's different
  int projectId;
  String status;
  String videoPath;
  String audioPath;
  List<dynamic> needs;
  UserModel vc;
  UserModel ve;


  ProjectModel({
    required this.projectId,
    required this.status,
    required this.videoPath,
    required this.needs,
    required this.audioPath,
    required this.vc,
    required this.ve,
  });

  factory ProjectModel.fromMap(Map<String, dynamic> json) {
    return ProjectModel(
      projectId: json['projectId'],
      status: json['status'] ?? '',
      videoPath: json['video Path'] ?? '',
      audioPath: json['audio Path'] ?? '',
      needs: json['needs'] ?? [],
      vc: UserModel.fromMap( json['VC']),
      ve: UserModel.fromMap( json['VE']) 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'projectId': projectId,
      'status': status,
      'video Path': videoPath,
      'audio': audioPath,
      'needs': needs,
      'VC': vc.toMap(),
      'VE': ve.toMap()
    };
  }
  static Future<List<ProjectModel>> getProjectsByQuery(
      {
         String? projectId,
    required String? status,
    int? vc,
    int? ve,
      }) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      Query query = firestore.collection('projects');

      // if (projectId != null) {
      //   query = query.where('projectId', isEqualTo: projectId).where('status',isEqualTo: status);
      // }

      // if (status != null) {
      //   query = query.where('status', isEqualTo: status);
      // }

      if (vc != null && ve != null) {
        query = query.where('status',isEqualTo: status).where('VC.id', isEqualTo: vc).where('VE.id', isEqualTo: ve);
      }
      else if (vc != null) {
        query = query.where('status',isEqualTo: status).where('VC.id', isEqualTo: vc);
      }
      else if (ve != null) {
        query = query.where('status',isEqualTo: status).where('VE.id', isEqualTo: ve);
      }

      final QuerySnapshot querySnapshot = await query.get();

      final List<ProjectModel> projects = [];

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
       // print(docSnapshot.get("needs"));
        projects.add(ProjectModel.fromMap(docSnapshot.data() as Map<String, dynamic>));
      }

      return projects;
    } catch (e) {
      // Handle any errors or exceptions here
      print('Error fetching projects: $e');
      return [];
    }
  }
}
