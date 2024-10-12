import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/app_export.dart'; // Adjust this import as needed
import '../models/membre_rejoindre_model.dart'; // Ensure this path is correct
import '../models/userprofile_item_model.dart';

/// A provider class for the MembreRejoindreScreen.
class MembreRejoindreProvider extends ChangeNotifier {
  MembreRejoindreModel membreRejoindreModelObj = MembreRejoindreModel();
  List<UserprofileItemModel> participants = []; // List to hold participant data

  MembreRejoindreProvider() {
    _fetchParticipants();
  }

  /// Fetch participants from Firestore
  void _fetchParticipants() {
    FirebaseFirestore.instance.collection('participants').snapshots().listen((snapshot) {
      participants = snapshot.docs.map((doc) {
        return UserprofileItemModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
      notifyListeners(); // Notify listeners to rebuild the UI
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
