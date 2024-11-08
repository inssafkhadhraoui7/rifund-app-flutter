import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../models/communitycardsection_item_model.dart';

class ListeDeCommunautProvider with ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  List<CommunitycardsectionItemModel> _communities = [];

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<CommunitycardsectionItemModel> get communities => _communities;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 Future<void> fetchAllCommunities() async {
  _isLoading = true;
  _errorMessage = '';
  notifyListeners();

  String? userId = _auth.currentUser?.uid;

  if (userId == null) {
    _errorMessage = 'Vous devez être connecté';
    _isLoading = false;
    notifyListeners();
    return;
  }

  try {
    final projectsSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('projects')
        .get();

    if (projectsSnapshot.docs.isEmpty) {
      _errorMessage = 'Aucun projet trouvé pour cet utilisateur.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    _communities = [];

    for (var projectDoc in projectsSnapshot.docs) {
      final projectId = projectDoc.id;
      final projectName = projectDoc.data()['title'] ?? 'Unnamed Project';

      final communitiesSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('projects')
          .doc(projectId)
          .collection('communities')
          .get();

      for (var communityDoc in communitiesSnapshot.docs) {
        final communityData = communityDoc.data();
        String name = communityData['name'] ?? 'Unknown Community';
        String description = communityData['description'] ?? 'No description available';
        String imageUrl = communityData['webUrl'] ?? '';

        if (imageUrl.isEmpty) {
          try {
            final storageRef = FirebaseStorage.instance
                .ref()
                .child('community_img/${communityDoc.id}.jpg');
            imageUrl = await storageRef.getDownloadURL();
          } catch (e) {
            print('Error fetching image for community $name: $e');
            imageUrl = 'default_image_url';
          }
        }

        _communities.add(CommunitycardsectionItemModel(
          communityId: communityDoc.id,
          projectId: projectId,
          name: name,
          description: description,
          imageUrl: imageUrl,
          projectName: projectName,
        ));
      }
    }

    print("Total communities fetched: ${_communities.length}");
  } catch (e) {
    _errorMessage = "Erreur lors de la récupération des communautés: ${e.toString()}";
    print("Error: $e");
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  Future<void> deleteCommunity(String projectId, String communityId) async {
  String? userId = _auth.currentUser?.uid;
  if (userId == null) {
    throw Exception("Vous devez être connecté");
  }

  try {
    print("Deleting community with ID: $communityId under project ID: $projectId for user: $userId");
    
    DocumentReference communityDoc = _firestore
        .collection('users')
        .doc(userId)
        .collection('projects')
        .doc(projectId)
        .collection('communities')
        .doc(communityId);

    DocumentSnapshot communitySnapshot = await communityDoc.get();

    if (communitySnapshot.exists) {
      print("Document exists. Proceeding to delete.");
      await communityDoc.delete();
      print("Communauté supprimée de Firestore!");
      await fetchAllCommunities(); // Refresh the list after deletion
    } else {
      print("Document does not exist. Cannot delete.");
    }
  } catch (e) {
    print("Erreur lors de la suppression de la communauté: ${e.toString()}");
    throw Exception("Erreur lors de la suppression de la communauté: ${e.toString()}");
  }
}

Future<void> updateCommunity(
  String projectId,
  String communityId,
  String newName,
  String newDescription,
  XFile? newImage,
) async {
  String? userId = _auth.currentUser?.uid;
  if (userId == null) {
    _errorMessage = "Vous devez être connecté";
    notifyListeners();
    return;
  }

  try {
    DocumentReference communityDoc = _firestore
        .collection('users')
        .doc(userId)
        .collection('projects')
        .doc(projectId)
        .collection('communities')
        .doc(communityId);

    // Update data map
    Map<String, dynamic> updatedData = {
      'name': newName,
      'description': newDescription,
    };

    // Handle image upload if a new image is selected
    if (newImage != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('community_img/${communityId}.jpg');

      // Upload the image to Firebase Storage
      await storageRef.putFile(File(newImage.path));
      String downloadURL = await storageRef.getDownloadURL();
      updatedData['webUrl'] = downloadURL;
    }

    // Update Firestore document
    await communityDoc.update(updatedData);
    print("Community updated successfully!");

    // Refresh local data
    await fetchAllCommunities();
  } catch (e) {
    _errorMessage = "Erreur lors de la mise à jour de la communauté: ${e.toString()}";
    print("Error updating community: $e");
  }
}

}
