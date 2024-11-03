import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AjoutCatGorieProvider extends ChangeNotifier {
  TextEditingController? categorynameController = TextEditingController();
  List<String> imageUrls = [];
  String? _categoryNameError;
  String selectedImageName = '';

  String? validateCategoryName(String? value) {
    if (value == null || value.isEmpty) {
      _categoryNameError = 'Le nom de catégorie ne peut pas être vide';
    } else if (value.length < 3) {
      _categoryNameError =
          'Le nom de catégorie doit comporter au moins 3 caractères';
    } else {
      _categoryNameError = null;
    }
    notifyListeners();
    return _categoryNameError;
  }

  Future<void> uploadImages(List<String> paths) async {
    final storage = FirebaseStorage.instance;
    for (String path in paths) {
      File file = File(path);
      try {
        TaskSnapshot snapshot = await storage
            .ref('categories/${file.uri.pathSegments.last}')
            .putFile(file);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      } catch (e) {
        print("Erreur de telechargement image: $e");
      }
    }
  }

  void setSelectedImageName(String name) {
    selectedImageName = name;
    notifyListeners();
  }

  String? get categoryNameError => _categoryNameError;

  Future<void> addCategory() async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('categories').add({
      'name': categorynameController?.text,
      'imageUrls': imageUrls,
    });

    categorynameController?.clear();
    imageUrls.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    categorynameController?.dispose();
    super.dispose();
  }
}
