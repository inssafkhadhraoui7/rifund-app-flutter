import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rifund/screens/liste_de_communaut_page/models/communitycardsection_item_model.dart';

class ListeDeCommunautProvider with ChangeNotifier {
  List<CommunitycardsectionItemModel> _communities = [];
  String _errorMessage = '';
  bool _isLoading = false;

  List<CommunitycardsectionItemModel> get communities => _communities;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> fetchCommunities() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('communities').get();

      // Fetch each community and its image URL from Firebase Storage
      _communities = await Future.wait(querySnapshot.docs.map((doc) async {
        String imageUrl = await FirebaseStorage.instance
            .ref('communityImages/${doc.id}')  // Assumes image is stored using the document ID
            .getDownloadURL();

        return CommunitycardsectionItemModel(
          name: doc['name'],
          description: doc['description'],
          imageUrl: imageUrl,
        );
      }).toList());

      _errorMessage = "";
    } catch (e) {
      _errorMessage = "Error fetching communities: ${e.toString()}";
    }

    _isLoading = false;
    notifyListeners();
  }
}
