import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AffichageCommunautProvider with ChangeNotifier {
  final String communityId;
  final String projectId;
  final String userId;

  AffichageCommunautProvider(this.userId, this.projectId, this.communityId) {
    // Print the communityId to the terminal for debugging
    print("AffichageCommunautProvider initialized with communityId: $userId, $projectId, $communityId");
  }

  String _communityName = '';
  String _communityDescription = '';
  String _communityImage = '';
  String _creationDate = '';
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  String get communityName => _communityName;
  String get communityDescription => _communityDescription;
  String get communityImage => _communityImage;
  String get creationDate => _creationDate;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  Future<void> fetchCommunityDetails() async {
    _isLoading = true;
    notifyListeners();

    try {
      print("Attempting to fetch community with ID: $userId $projectId  $communityId");

      // Use a document reference to get the specific community document
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('projects')
          .doc(projectId)
          .collection('communities')
          .doc(communityId) // Use communityId here
          .get();

      if (documentSnapshot.exists) {
        // Cast the snapshot to Map<String, dynamic>
        var snapshot = documentSnapshot.data() as Map<String, dynamic>;
        _communityName = snapshot['name'] ?? 'No name provided';
        _communityDescription = snapshot['description'] ?? 'No description available';
        _creationDate = snapshot['createdAt']?.toDate().toString() ?? '';
        String imageUrl = snapshot['webUrl'] ?? '';

        if (imageUrl.isEmpty) {
          try {
            final storageRef = FirebaseStorage.instance
                .ref()
                .child('community_img/${documentSnapshot.id}.jpg'); // Use documentSnapshot.id here
            imageUrl = await storageRef.getDownloadURL();
          } catch (e) {
            print('Error fetching image for community $_communityName: $e');
            imageUrl = 'default_image_url'; // Use a default image URL
          }
        }

        _communityImage = imageUrl; // Update the community image
      } else {
        _hasError = true;
        _errorMessage = 'Community not found';
        print(_errorMessage);
      }
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Error fetching community details: ${e.toString()}';
      print(_errorMessage);
    } finally {
      _isLoading = false; // Ensure loading is set to false
      notifyListeners();
    }
  }

  // New method to upload an image
}
