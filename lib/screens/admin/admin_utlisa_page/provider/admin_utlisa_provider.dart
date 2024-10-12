import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rifund/screens/admin/admin_utlisa_page/models/userprofile_item_model.dart';

class AdminUtlisaProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to fetch all users from Firestore
  Future<List<CustomUser>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      print("Fetched ${querySnapshot.docs.length} users");

      if (querySnapshot.docs.isEmpty) {
        print("No users found in Firestore");
        return [];
      }

      return querySnapshot.docs.map((doc) {
        print("User: ${doc.id}, ${doc['email']}");
        return CustomUser.fromFirestore(doc);
      }).toList();
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }

  // Method to accept a user
  Future<void> acceptUser(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'isAccepted': true,
      });
      notifyListeners();
    } catch (e) {
      print("Error accepting user: $e");
    }
  }

  // Method to block a user
  Future<void> blockUser(String uid, BuildContext context) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'isBlocked': true,
      });
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User blocked")));
    } catch (e) {
      print("Error blocking user: $e");
    }
  }

  // Method to delete a user
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
