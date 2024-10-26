import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/admin_cat_gorie_model.dart';

class AdminCatGorieProvider extends ChangeNotifier {
  List<AdminCatGorieModel> categories = [];
  bool isLoading = false; // Loading state
  String? errorMessage; // Error message

  Future<void> fetchCategories() async {
    isLoading = true; // Set loading state
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance.collection('categories').get();
      categories = snapshot.docs.map((doc) => AdminCatGorieModel.fromMap(doc.data())).toList();
      errorMessage = null; // Clear previous error
    } catch (e) {
      errorMessage = "Error fetching categories: $e"; // Set error message
      print(errorMessage);
    } finally {
      isLoading = false; // Reset loading state
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
