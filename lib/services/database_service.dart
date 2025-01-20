import 'package:cloud_firestore/cloud_firestore.dart';

class DBService {
  static DBService instance = DBService();

  FirebaseFirestore? _db;
  DBService() {
    _db = FirebaseFirestore.instance;
  }

  String _userColllction = "Users";
  Future<void> createUserInDB(
      String _uid, String _name, String _email, String _imageURL) async {
    try {
    return await _db!.collection(_userColllction).doc(_uid).set({
      "name": _name,
      "email": _email,
      "last_active": DateTime.now().millisecondsSinceEpoch.toString(),
      "image":_imageURL,
      "about":"hi email",
    "is_online":false,
    "created_at":DateTime.now().millisecondsSinceEpoch.toString(),
    "id":_uid,
    "pushtoken":"",
    });  
    } catch (e) {
      print(e);
    }
    
  }
}
