import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rifund/screens/admin/admin_utlisa_page/models/userprofile_item_model.dart';


class AdminUtlisaProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CustomUser>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      print("Fetched ${querySnapshot.docs.length} users"); // Debugging line
      List<CustomUser> users = querySnapshot.docs.map((doc) {
        print("User: ${doc.id}, ${doc['email']}"); // Debugging line
        return CustomUser.fromFirestore(doc);
      }).toList();
      return users;
    } catch (e) {
      print("Error fetching users: $e");
      return []; // Return an empty list on error
    }
  }

  Future<void> acceptUser(String uid) async {
    try {
      // Optionally, you might want to update user status in Firestore
      await _firestore.collection('users').doc(uid).update({
        'isAccepted': true, // Example field to mark the user as accepted
      });
      notifyListeners(); // Notify listeners after updating
    } catch (e) {
      print("Error accepting user: $e");
    }
  }

  Future<void> blockUser(String uid, BuildContext context) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'isBlocked': true, // Example field to block the user
      });
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User blocked")));
    } catch (e) {
      print("Error blocking user: $e");
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
      print("Deleted user with uid: $uid");
      notifyListeners();
    } catch (e) {
      print("Error deleting user: $e");
    }
  }
}
