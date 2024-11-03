import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/admin_cat_gorie_model.dart';

class AdminCategoryProvider extends ChangeNotifier {
  List<AdminCategoryModel> categories = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchCategories() async {
    try {
      // Your logic to fetch data from Firestore
      // Assuming you have a collection called 'categories'
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('categories').get();

      categories = snapshot.docs.map((doc) {
        return AdminCategoryModel.fromMap(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteCategory(String categoryId, String imageUrl) async {
    isLoading = true;
    notifyListeners();

    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .delete();

      if (imageUrl.isNotEmpty) {
        await FirebaseStorage.instance.refFromURL(imageUrl).delete();
      }

      categories.removeWhere((category) => category.id == categoryId);
    } catch (e) {
      errorMessage = "Erreur de suppression categorie : $e";
      print(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _deleteImageIfExists(String? imageUrl) async {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();
    }
  }

  Future<void> updateCategory(String categoryId, String name,
      String? newImageUrl, String? oldImageUrl) async {
    isLoading = true;
    notifyListeners();

    try {
      if (newImageUrl != null && newImageUrl != oldImageUrl) {
        if (oldImageUrl != null) {
          await FirebaseStorage.instance.refFromURL(oldImageUrl).delete();
        }
      }

      await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .update({
        'name': name,
        'imageUrls': newImageUrl != null ? [newImageUrl] : [],
      });

      final categoryIndex =
          categories.indexWhere((cat) => cat.id == categoryId);
      if (categoryIndex != -1) {
        categories[categoryIndex] = AdminCategoryModel(
          id: categoryId,
          name: name,
          imageUrl: newImageUrl ?? oldImageUrl,
        );
      }

      errorMessage = null;
    } catch (e) {
      errorMessage = "Erreur de modification categorie: $e";
      print(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
