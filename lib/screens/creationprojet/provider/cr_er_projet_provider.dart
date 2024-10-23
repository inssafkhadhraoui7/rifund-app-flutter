import 'dart:io';
<<<<<<< HEAD

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
=======
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
>>>>>>> ahmed
import 'package:firebase_auth/firebase_auth.dart';
import '../models/modelcrprojet.dart';

class CrErProjetProvider extends ChangeNotifier {
  TextEditingController projectTitleController = TextEditingController();
  TextEditingController descriptionValueController = TextEditingController();
  TextEditingController projectImagesController = TextEditingController();
  TextEditingController budgetValueController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController compteController = TextEditingController();

  CrErProjetModel crErProjetModelObj = CrErProjetModel();
  
  List<String> selectedImagePaths = [];
  List<String> selectedImageNames = [];
  String? selectedCategory;

  @override
  void dispose() {
    projectTitleController.dispose();
    descriptionValueController.dispose();
    projectImagesController.dispose();
    budgetValueController.dispose();
    dateController.dispose();
    compteController.dispose();
<<<<<<< HEAD
  }

  List<String> selectedImagePaths = [];
  List<String> selectedImageNames = [];

  void updateSelectedImages(List<String> paths, List<String> names) {
    selectedImagePaths = paths;
    selectedImageNames = names;
    notifyListeners();
  }

  Future<List<String>> uploadImages(List<String> imagePaths) async {
    List<String> imageUrls = [];
    FirebaseStorage storage = FirebaseStorage.instance;
    
    // Get the current user's ID
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      throw Exception('User is not authenticated');
    }

    for (String path in imagePaths) {
      File file = File(path);
      try {
        // Create a unique name for the image under the user's ID
        String fileName = 'users/$userId/images/${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';

        // Upload the file
        TaskSnapshot snapshot = await storage.ref(fileName).putFile(file);

        // Get the download URL
        String downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      } catch (e) {
        print('Error uploading image: $e'); // Consider better error handling
      }
    }
    return imageUrls;
  }

  bool isImageSelectionValid() {
    return selectedImagePaths.length >= 1 && selectedImagePaths.length <= 5;
=======
    super.dispose();
>>>>>>> ahmed
  }

  void updateSelectedImages(List<String> paths, List<String> names) {
    selectedImagePaths = paths;
    selectedImageNames = names;
    notifyListeners();
  }

  Future<List<String>> uploadImages(List<String> imagePaths) async {
    List<String> imageUrls = [];
    FirebaseStorage storage = FirebaseStorage.instance;
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      throw Exception('User is not authenticated');
    }

    for (String path in imagePaths) {
      File file = File(path);
      try {
        String fileName = 'users/$userId/images/${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';
        TaskSnapshot snapshot = await storage.ref(fileName).putFile(file);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      } catch (e) {
        print('Error uploading image: $e');
        // Optionally, show a dialog or snackbar to the user
      }
    }
    return imageUrls;
  }

  bool isImageSelectionValid() {
    return selectedImagePaths.length >= 1 && selectedImagePaths.length <= 5;
  }

  void onSelectedDropdownItem(dynamic value) {
    for (var element in crErProjetModelObj.dropdownItemList) {
      element.isSelected = element.id == value.id;
    }
    notifyListeners();
  }

<<<<<<< HEAD
  onSelected1(dynamic value) {
    for (var element in crErProjetModelObj.categoryDropdownItemList) {
      element.isSelected = false;
      if (element.id == value.id) {
        element.isSelected = true;
      }
=======
  void onSelectedCategoryItem(dynamic value) {
    for (var element in crErProjetModelObj.categoryDropdownItemList) {
      element.isSelected = element.id == value.id;
>>>>>>> ahmed
    }
    notifyListeners();
  }

  void updateSelectedCategory(String? value) {
    selectedCategory = value;
    notifyListeners(); // Notify listeners to rebuild the UI
  }
}
