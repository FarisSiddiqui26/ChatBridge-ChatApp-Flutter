import 'package:chatbridge/Models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static get user => auth.currentUser!;

  static late ChatUser me;
  static Future<bool> userExist() async {
    return (await firestore.collection('Users').doc(user!.uid).get()).exists;
  }

  static Future<void> getSelfInfo() async {
    return await firestore
        .collection('Users')
        .doc(user.uid)
        .get()
        .then((user) async {
          if (user.exists) {
            me = ChatUser.fromJson(user.data()!);
          }else{
           await Createuser().then((value)=>getSelfInfo());
          }
        });
  }

  // for creating
  static Future<void> Createuser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey!",
      image: user.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: "",
    );
    return await firestore
        .collection('Users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('Users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }
}
