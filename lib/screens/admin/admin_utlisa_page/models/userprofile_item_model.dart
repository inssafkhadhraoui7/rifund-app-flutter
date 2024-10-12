import 'package:cloud_firestore/cloud_firestore.dart';

class CustomUser {
  final String uid;
  final String email;

  CustomUser({required this.uid, required this.email});

  factory CustomUser.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>; // Cast the data to Map
    return CustomUser(
      uid: doc.id,
      email: data['email'] ?? 'No Email',
    );
  }
}
