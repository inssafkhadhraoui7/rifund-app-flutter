import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/modelcrprojet.dart';

/// A provider class for the CrErProjetScreen.
///
/// This provider manages the state of the CrErProjetScreen, including the
/// current crErProjetModelObj
// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class CrErProjetProvider extends ChangeNotifier {
  TextEditingController projectTitleController = TextEditingController();

  TextEditingController descriptionValueController = TextEditingController();

  TextEditingController projectImagesController = TextEditingController();

  TextEditingController budgetValueController = TextEditingController();

  TextEditingController dateController = TextEditingController();

  TextEditingController compteController = TextEditingController();

  CrErProjetModel crErProjetModelObj = CrErProjetModel();

  @override
  void dispose() {
    super.dispose();
    projectTitleController.dispose();
    descriptionValueController.dispose();
    projectImagesController.dispose();
    budgetValueController.dispose();
    dateController.dispose();
    compteController.dispose();
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
  }

  onSelected(dynamic value) {
    for (var element in crErProjetModelObj.dropdownItemList) {
      element.isSelected = false;
      if (element.id == value.id) {
        element.isSelected = true;
      }
    }
    notifyListeners();
  }

  onSelected1(dynamic value) {
    for (var element in crErProjetModelObj.categoryDropdownItemList) {
      element.isSelected = false;
      if (element.id == value.id) {
        element.isSelected = true;
      }
    }
    notifyListeners();
  }
}
