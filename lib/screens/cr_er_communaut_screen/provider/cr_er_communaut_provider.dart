import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../communityservice.dart';
import '../models/cr_er_communaut_model.dart';

class CrErCommunautProvider extends ChangeNotifier {
  TextEditingController createCommunityController = TextEditingController();
  TextEditingController descriptionValueController = TextEditingController();
  TextEditingController webUrlController = TextEditingController();

  String? projectId;
  String? userId;

  CrErCommunautModel crErCommunautModelObj = CrErCommunautModel();

  bool _isDisposed = false;
  List<String> selectedImagePaths = [];
  List<String> selectedImageNames = [];
  String? imageUrl; // To hold the image URL after upload

  void setProjectId(String id) {
    projectId = id;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  Future<void> fetchUserId() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
    } else {
      print('Utilisateur non authentifié');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    createCommunityController.dispose();
    descriptionValueController.dispose();
    webUrlController.dispose();
    super.dispose();
  }

  Future<void> createCommunity(BuildContext context) async {
    if (_isDisposed) return;

    await fetchUserId();

    if (createCommunityController.text.isEmpty ||
        descriptionValueController.text.isEmpty ||
        projectId == null ||
        userId == null ||
        !isImageSelectionValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs et réessayer.')),
      );
      return;
    }

    try {
      await CommunityService().createCommunity(
        name: createCommunityController.text,
        description: descriptionValueController.text,
        webUrl: imageUrl ?? webUrlController.text,
        userId: userId!,
        projectId: projectId!,
      );

      if (_isDisposed) return;
      _clearInputFields();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Communauté crée avec succès!')),
      );
    } catch (e) {
      if (!_isDisposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la création de la communauté: $e')),
        );
      }
    }
  }

  void _clearInputFields() {
    createCommunityController.clear();
    descriptionValueController.clear();
    webUrlController.clear();
    selectedImagePaths.clear();
    selectedImageNames.clear();
    imageUrl = null;
    notifyListeners();
  }

  Future<void> updateSelectedImage(String path, String name) async {
    selectedImagePaths = [path];
    selectedImageNames = [name];
    if (!_isDisposed) {
      notifyListeners();
    }

    // Upload image to Firebase Storage
    try {
      String storagePath = 'community_img/$name';
      final ref = FirebaseStorage.instance.ref().child(storagePath);
      await ref.putFile(File(path));
      imageUrl = await ref.getDownloadURL();
      print('Image téléchargée et URL obtenue: $imageUrl');
    } catch (e) {
      print('Erreur lors du téléchargement de limage: $e');
    }
  }

  bool isImageSelectionValid() {
    return selectedImagePaths.isNotEmpty;
  }
}
