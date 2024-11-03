import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rifund/screens/profile_screen/models/profile_model.dart';

class ProfileProvider with ChangeNotifier {
  String profileImageUrl = '';


 Future<void> fetchUserProfileData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          profileImageUrl = userDoc['image_user'] ?? ''; // Fetch the image URL
        }
        notifyListeners(); // Notify listeners to update the UI
      } catch (e) {
        print("Error fetching user profile data: $e");
      }
    }
  }

  void updateProfileImage(String url) {
    profileImageUrl = url;
    notifyListeners(); // Notify listeners about the change
  }
}