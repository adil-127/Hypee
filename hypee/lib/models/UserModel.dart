import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  int? id;
  String? firstname;
  String? lastname;
  String? email;
  String? profile;
  String? role;
  String? pushToken;
  Map<String,dynamic>? additionalFields;
  UserModel({this.id, this.firstname, this.lastname, this.email, this.profile, this.role});

  UserModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    firstname = map["Firstname"];
    lastname = map["Lastname"];
    email = map["email"];
    profile = map["profile"];
    role = map["role"];
    additionalFields = map['additionalFields'];
    pushToken = map['pushToken'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "Firstname": firstname,
      "Lastname": lastname,
      "email": email,
      "profile": profile,
      "role" : role,
      "additionalFields": additionalFields,
      "pushToken" : pushToken
    };
  }
}
class Users{
  Future<List<UserModel>> get videoEditor async{
    final getlistings = await FirebaseFirestore.instance.collection("usersData").where("role",isEqualTo: "VE").get();
    List<UserModel> users = getlistings.docs.map((document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      UserModel user = UserModel.fromMap(data);
      return user;
    }).toList();
    print(users);
    return users;
  }
}