import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/cr_er_communaut_model.dart';

class CrErCommunautProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController createCommunityController = TextEditingController();
  TextEditingController descriptionValueController = TextEditingController();
  TextEditingController webUrlController = TextEditingController();

  CrErCommunautModel crErCommunautModelObj = CrErCommunautModel();

  @override
  void dispose() {
    super.dispose();
    createCommunityController.dispose();
    descriptionValueController.dispose();
    webUrlController.dispose();
  }

  Future<void> createCommunity() async {
    try {
      String name = createCommunityController.text.trim();
      String description = descriptionValueController.text.trim();
      String webUrl = webUrlController.text.trim();

      // Create a new community document in Firestore
      await _firestore.collection('communities').add({
        'name': name,
        'description': description,
        'webUrl': webUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Optionally clear the text fields after saving
      createCommunityController.clear();
      descriptionValueController.clear();
      webUrlController.clear();

      // Notify listeners to update UI if needed
      notifyListeners();
    } catch (e) {
      // Handle errors (e.g., show a snackbar or dialog)
      print('Error creating community: $e');
    }
  }
}
