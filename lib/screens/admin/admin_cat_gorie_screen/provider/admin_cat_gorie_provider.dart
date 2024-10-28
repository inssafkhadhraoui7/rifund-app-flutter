import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/admin_cat_gorie_model.dart';

class AdminCatGorieProvider extends ChangeNotifier {
  List<AdminCatGorieModel> categories = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchCategories() async {
    isLoading = true;
    notifyListeners();

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('categories').get();
      categories = snapshot.docs.map((doc) {
        return AdminCatGorieModel.fromMap(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      errorMessage = null;
    } catch (e) {
      errorMessage = "Erreur de telechargement categories: $e";
      print(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCategory(String categoryId, String imageUrl) async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .delete();

      if (imageUrl.isNotEmpty) {
        await FirebaseStorage.instance.refFromURL(imageUrl).delete();
      }

      categories.removeWhere((category) => category.id == categoryId);
      notifyListeners();
    } catch (e) {
      errorMessage = "Error deleting category: $e";
      print(errorMessage);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
