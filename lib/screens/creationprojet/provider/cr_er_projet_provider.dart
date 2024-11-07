import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rifund/core/utils/image_constant.dart';
import 'package:rifund/screens/listeprojets/models/userprofile_item_model.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../models/modelcrprojet.dart';

class CrErProjetProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

  String get selectedCurrency {
    return crErProjetModelObj.dropdownItemList
        .firstWhere((item) => item.isSelected,
            orElse: () => crErProjetModelObj.dropdownItemList.first)
        .title;
  }

  set selectedCurrency(String value) {
    for (var item in crErProjetModelObj.dropdownItemList) {
      item.isSelected = item.title == value;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    projectTitleController.dispose();
    descriptionValueController.dispose();
    projectImagesController.dispose();
    budgetValueController.dispose();
    dateController.dispose();
    compteController.dispose();
    super.dispose();
  }

  void updateSelectedImages(List<String> paths, List<String> names) {
    selectedImagePaths = paths;
    selectedImageNames = names;
    notifyListeners();
  }

  Future<void> createUserProject() async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception("Utilisateur pas connecté");
    }

    String title = projectTitleController.text;
    String description = descriptionValueController.text;
    List<String> imageUrls = await uploadImages(selectedImagePaths);
    String budget = budgetValueController.text;
    String date = dateController.text;
    String? accountNumber = compteController.text;

    Map<String, dynamic> projectData = {
      'title': title,
      'description': description,
      'images': imageUrls,
      'budget': budget,
      'date': date,
      'accountNumber': accountNumber,
      'currency': selectedCurrency,
      'category': selectedCategory,
      'userId': userId, // Include userId in the data.
    };

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('projects')
          .add(projectData);

      notifyListeners();
    } catch (error) {
      print('Error creating project: $error');
      throw Exception('Failed to create project: $error');
    }
  }

  Future<List<UserprofileItemModel>> fetchUserProjects() async {
    String? userId = _auth.currentUser?.uid;

    if (userId == null) {
      throw Exception('Il faut être connecté');
    }

    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('projects')
        .get();

    List<UserprofileItemModel> projects = snapshot.docs.map((doc) {
      String title = doc['title'] ?? 'Pas de titre';
      List<String> images = List<String>.from(doc['images'] ?? []);
      String projectId = doc.id;

      return UserprofileItemModel(
        id: projectId,
        titreduprojet: title,
        circleimage: images.isNotEmpty ? images[0] : ImageConstant.imgprofile,
        // Uncomment if financing percentage is available
        // seventy: '${(doc['financedPercentage'] ?? 0.0 * 100).toStringAsFixed(0)} %',
      );
    }).toList();

    print('Fetched projects: ${projects.length}');

    return projects;
  }

  Future<void> updateUserProject(String? projectId) async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception("Utilisateur pas connecté");
    }

    String title = projectTitleController.text;
    String description = descriptionValueController.text;
    List<String> imageUrls = await uploadImages(selectedImagePaths);
    String budget = budgetValueController.text;
    String date = dateController.text;
    String? accountNumber = compteController.text;

    Map<String, dynamic> projectData = {
      'title': title,
      'description': description,
      'images': imageUrls,
      'budget': budget,
      'date': date,
      'accountNumber': accountNumber,
      'currency': selectedCurrency,
      'category': selectedCategory,
      'userId': userId,
    };

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('projects')
          .doc(projectId)
          .update(projectData);

      notifyListeners();
    } catch (error) {
      print('Error updating project: $error');
      throw Exception('Failed to update project: $error');
    }
  }

  Future<void> loadUserProjectForEditing(String projectId) async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception("User is not authenticated");
      }

      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('projects')
          .doc(projectId)
          .get();

      if (doc.exists) {
        var projectData = doc.data() as Map<String, dynamic>;
        projectTitleController.text = projectData['title'] ?? '';
        descriptionValueController.text = projectData['description'] ?? '';
        projectImagesController.text =
            (projectData['images'] as List).isNotEmpty
                ? projectData['images'][0]
                : '';
        budgetValueController.text = projectData['budget']?.toString() ?? '';
        dateController.text = projectData['date'] ?? '';
        compteController.text = projectData['accountNumber'] ?? '';

        selectedCurrency = projectData['currency'] ?? 'USD';
        selectedCategory = projectData['category'] ?? null;
      }
    } catch (e) {
      print('Error loading project for editing: $e');
    }
  }

  Future<List<String>> uploadImages(List<String> imagePaths) async {
    List<String> imageUrls = [];
    String? userId = _auth.currentUser?.uid;

    if (userId == null) {
      throw Exception('User is not authenticated');
    }

    for (String path in imagePaths) {
      File file = File(path);
      try {
        String fileName =
            'users/$userId/images/${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';
        TaskSnapshot snapshot = await _storage.ref(fileName).putFile(file);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      } catch (e) {
        print('Erreur de telechargement image: $e');
      }
    }
    return imageUrls;
  }

  bool isImageSelectionValid() {
    return selectedImagePaths.length >= 1 && selectedImagePaths.length <= 5;
  }

  void onSelectedDropdownItem(SelectionPopupModel value) {
    for (var element in crErProjetModelObj.dropdownItemList) {
      element.isSelected = element.id == value.id;
    }
    notifyListeners();
  }

  void onSelectedCategoryItem(SelectionPopupModel value) {
    for (var element in crErProjetModelObj.categoryDropdownItemList) {
      element.isSelected = element.id == value.id;
    }
    notifyListeners();
  }

  void updateSelectedCategory(String? value) {
    selectedCategory = value;
    notifyListeners();
  }

  Future<void> initializeCategories() async {
    await crErProjetModelObj.initCategoryDropdown();
    notifyListeners();
  }
}
