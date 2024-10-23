import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication
import 'package:flutter/material.dart';
import 'package:rifund/screens/liste_de_communaut_page/models/communitycardsection_item_model.dart';

class ListeDeCommunautProvider with ChangeNotifier {
  List<CommunitycardsectionItemModel> _communities = [];
  String _errorMessage = '';
  bool _isLoading = false;

  List<CommunitycardsectionItemModel> get communities => _communities;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  // Fetch all communities for a specific project
  Future<void> fetchCommunities(String projectId) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = ''; // Clear previous error message
    notifyListeners();

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        _errorMessage = 'User is not authenticated.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      String userId = currentUser.uid;

      // Construct the Firestore collection path
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('projects')
          .doc(projectId)
          .collection('communities')
          .get();

      // Fetch each community and its image URL from Firebase Storage
      _communities = await Future.wait(querySnapshot.docs.map((doc) async {
        try {
          String imageUrl = await FirebaseStorage.instance
              .ref('community_images/${doc.id}') // Assumes image is stored using the document ID
              .getDownloadURL();

          return CommunitycardsectionItemModel(
            name: doc['name'],
            description: doc['description'],
            imageUrl: imageUrl,
          );
        } catch (e) {
          print("Error fetching image for community ${doc.id}: $e");
          return CommunitycardsectionItemModel(
            name: doc['name'],
            description: doc['description'],
            imageUrl: '', // Fallback to empty string if image fails to load
          );
        }
      }).toList());

      _errorMessage = ""; // Clear error message after successful fetch
    } catch (e) {
      _errorMessage = "Error fetching communities: ${e.toString()}"; // Set error message
      print("Error: $e"); // Log error for debugging
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners after finishing loading
    }
  }

  // Fetch a specific community by ID
  Future<CommunitycardsectionItemModel?> fetchCommunityById(String projectId, String communityId) async {
    if (_isLoading) return null;

    _isLoading = true;
    _errorMessage = ''; // Clear previous error message
    notifyListeners();

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        _errorMessage = 'User is not authenticated.';
        _isLoading = false;
        notifyListeners();
        return null;
      }

      String userId = currentUser.uid;

      // Fetch the community document by ID
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('projects')
          .doc(projectId)
          .collection('communities')
          .doc(communityId)
          .get();

      if (doc.exists) {
        // Fetch the image URL from Firebase Storage
        String imageUrl = await FirebaseStorage.instance
            .ref('imagescom/$communityId') // Assumes image is stored using the community document ID
            .getDownloadURL();

        return CommunitycardsectionItemModel(
          name: doc['name'],
          description: doc['description'],
          imageUrl: imageUrl,
        );
      } else {
        _errorMessage = 'Community not found.';
        return null;
      }
    } catch (e) {
      _errorMessage = "Error fetching community: ${e.toString()}"; // Set error message
      print("Error: $e"); // Log error for debugging
      return null;
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners after finishing loading
    }
  }
}
