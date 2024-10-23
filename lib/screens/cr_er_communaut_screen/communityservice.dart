import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommunityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createCommunity({
    required String name,
    required String description,
    String? webUrl,
    required String userId,
    required String projectId, // Required project ID
  }) async {
    try {
      if (projectId.isEmpty) {
        throw Exception('Project ID must not be empty.');
      }

      // Create a reference to the user's specific project collection
      DocumentReference projectRef = _firestore
          .collection('users') // Reference to the 'users' collection
          .doc(userId) // Reference to the user document
          .collection('projects') // Reference to the 'projects' sub-collection
          .doc(projectId); // Reference to the specific project document

      // Add the community document under the specific project's subcollection
      await projectRef.collection('communities').add({
        'name': name,
        'description': description,
        'webUrl': webUrl,
        'userId': userId,
        'projectId': projectId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Community successfully created under user ID: $userId, project ID: $projectId');
      
    } catch (e) {
      throw Exception('Error creating community: $e');
    }
  }
}
