import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  static Future<UserModel?> getUserModelById(String uid) async {
    UserModel? userModel;
    DocumentSnapshot? snapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    userModel = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);

    return userModel;
  }
}
