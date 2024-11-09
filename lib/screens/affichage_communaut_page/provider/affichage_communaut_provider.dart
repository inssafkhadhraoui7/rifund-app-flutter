import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AffichageCommunautProvider with ChangeNotifier {
  String communityId = '';
  String projectId = '';
  String userId = '';

  void setup(String userId, String projectId, String communityId) {
    if (projectId.isEmpty || communityId.isEmpty) {
      log('Error:  projectId, or communityId is empty.');
      throw Exception(
          'Required parameters ( projectId, communityId) are missing.');
    }
    this.projectId = projectId;
    this.communityId = communityId;
    this.userId = userId;
    notifyListeners();
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

  String get getProjectId => projectId;
  String get getCommunityId => communityId;

  Future<void> fetchCommunityDetails() async {
    log('projectId: $projectId, communityId: $communityId');
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    if (projectId.isEmpty || communityId.isEmpty) {
      _hasError = true;
      _errorMessage = 'Invalid community information';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('projects')
          .doc(projectId)
          .collection('communities')
          .doc(communityId)
          .get();

      if (documentSnapshot.exists) {
        final snapshot = documentSnapshot.data() as Map<String, dynamic>;
        _communityName = snapshot['name'] ?? 'No name provided';
        _communityDescription =
            snapshot['description'] ?? 'No description available';
        _creationDate = snapshot['createdAt']?.toDate().toString() ?? '';
        _communityImage = snapshot['webUrl'] ?? '';
      } else {
        _hasError = true;
        _errorMessage = 'Community not found';
      }
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Error fetching community details: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> quitCommunity() async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid == null || projectId.isEmpty || communityId.isEmpty) {
      _hasError = true;
      _errorMessage = 'Invalid user or community information';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Reference to the "membres" collection in Firestore
      final communityRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('projects')
          .doc(projectId)
          .collection('communities')
          .doc(communityId)
          .collection('membres');

      // Delete the document with the currentUserUid in the "membres" collection
      await communityRef.doc(currentUserUid).delete();

      _hasError = false;
      _errorMessage = '';
      log('User successfully removed from the community');
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Error quitting the community: ${e.toString()}';
      log(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
