import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CrErCommunautProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController createCommunityController = TextEditingController();
  TextEditingController descriptionValueController = TextEditingController();
  TextEditingController webUrlController = TextEditingController();

  Future<void> createCommunity(String userId, String projectId) async {
    try {
      String communityName = createCommunityController.text;
      String description = descriptionValueController.text;
      String webUrl = webUrlController.text;

      await _firestore.collection('communities').add({
        'name': communityName,
        'description': description,
        'webUrl': webUrl,
        'userId': userId,
        'projectId': projectId,
      });

      notifyListeners();
    } catch (e) {
      throw Exception("Failed to create community: $e");
    }
  }
}
