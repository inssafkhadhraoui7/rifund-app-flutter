import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/admin_cat_gorie_model.dart';

class AdminCatGorieProvider extends ChangeNotifier {
  List<AdminCatGorieModel> categories = [];
  bool isLoading = false; // Loading state
  String? errorMessage; // Error message

  Future<void> fetchCategories() async {
    isLoading = true; // Set loading state
    notifyListeners();

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('categories').get();
      categories = snapshot.docs.map((doc) {
        return AdminCatGorieModel.fromMap(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      errorMessage = null; // Clear previous error
    } catch (e) {
      errorMessage = "Error fetching categories: $e"; // Set error message
      print(errorMessage);
    } finally {
      isLoading = false; // Reset loading state
      notifyListeners();
    }
  }

  Future<void> deleteCategory(String categoryId, String imageUrl) async {
    try {
      // Delete the category document from Firestore
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .delete();

      // Delete the image from Firebase Storage
      if (imageUrl.isNotEmpty) {
        await FirebaseStorage.instance.refFromURL(imageUrl).delete();
      }

      // Remove the category from the list locally
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
