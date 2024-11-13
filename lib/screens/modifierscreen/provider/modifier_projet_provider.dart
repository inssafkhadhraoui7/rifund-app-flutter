import 'package:flutter/material.dart';
import 'package:rifund/data/models/selectionPopupModel/selection_popup_model.dart';

import '../../../core/app_export.dart';
import '../models/modifier_projet_model.dart';

/// A provider class for managing the state of the ModifierProjetScreen.
class ModifierProjetProvider extends ChangeNotifier {
  // Controllers for form fields
  TextEditingController projectTitleController = TextEditingController();
  TextEditingController descriptionValueController = TextEditingController();
  TextEditingController projectImagesController = TextEditingController();
  TextEditingController budgetValueOneController = TextEditingController();
  TextEditingController durationOneController = TextEditingController();
  TextEditingController comptecourantController = TextEditingController();

  // The model object that holds data for the project
  ModifierProjetModel modifierProjetModelObj = ModifierProjetModel();

  @override
  void dispose() {
    // Dispose of controllers when the provider is disposed
    projectTitleController.dispose();
    descriptionValueController.dispose();
    projectImagesController.dispose();
    budgetValueOneController.dispose();
    durationOneController.dispose();
    comptecourantController.dispose();
    super.dispose();
  }

  // Method to handle dropdown selection for currency
  void onSelectedCurrency(SelectionPopupModel value) {
    for (var element in modifierProjetModelObj.dropdownItemList) {
      element.isSelected = false;
      if (element.id == value.id) {
        element.isSelected = true;
      }
    }
    notifyListeners();
  }

  // Method to handle dropdown selection for categories
  void onSelectedCategory(SelectionPopupModel value) {
    for (var element in modifierProjetModelObj.categoryDropdownItemList) {
      element.isSelected = false;
      if (element.id == value.id) {
        element.isSelected = true;
      }
    }
    notifyListeners();
  }

  // Method to load existing project data into the form (e.g., when modifying a project)
  void loadProjectData({
    required String title,
    required String description,
    required String images,
    required String budget,
    required String duration,
    required String comptecourant,
    required double percentage,
    required List<SelectionPopupModel> currencyItems,
    required List<SelectionPopupModel> categoryItems,
  }) {
    projectTitleController.text = title;
    descriptionValueController.text = description;
    projectImagesController.text = images;
    budgetValueOneController.text = budget;
    durationOneController.text = duration;
    comptecourantController.text = comptecourant;

    modifierProjetModelObj.percentage = percentage;
    modifierProjetModelObj.dropdownItemList = currencyItems;
    modifierProjetModelObj.categoryDropdownItemList = categoryItems;

    // Ensure the selected items are set properly
    for (var item in modifierProjetModelObj.dropdownItemList) {
      item.isSelected =
          (item.title == budget); // Assuming 'budget' is linked to currency
    }

    for (var item in modifierProjetModelObj.categoryDropdownItemList) {
      item.isSelected = (item.title ==
          categoryItems.first.title); // Assuming first category is selected
    }

    notifyListeners(); // Update UI
  }

  // Method to save or submit project data
  Future<void> saveProjectData() async {
    // You would typically save the data here, for example:
    try {
      // Prepare the project data
      String selectedCurrency = modifierProjetModelObj.getSelectedCurrency();
      String selectedCategory = modifierProjetModelObj.getSelectedCategory();
      double percentage = modifierProjetModelObj.percentage;

      // Save to Firestore or backend
      await saveToDatabase(
        projectTitleController.text,
        descriptionValueController.text,
        projectImagesController.text,
        budgetValueOneController.text,
        durationOneController.text,
        comptecourantController.text,
        selectedCurrency,
        selectedCategory,
        percentage,
      );
    } catch (e) {
      // Handle error
      print("Error saving project data: $e");
    }
  }

  // Reset the form data (if needed, e.g., after submitting or clearing form)
  void resetForm() {
    projectTitleController.clear();
    descriptionValueController.clear();
    projectImagesController.clear();
    budgetValueOneController.clear();
    durationOneController.clear();
    comptecourantController.clear();

    modifierProjetModelObj = ModifierProjetModel(); // Reset the model

    notifyListeners();
  }

  // Future<void> updateProject(
  //     String projectId, String newTitle, String newImage) async {
  //   try {
  //     String? userId = FirebaseAuth.instance.currentUser?.uid;

  //     if (userId == null) {
  //       throw Exception("User is not authenticated");
  //     }

  //     Map<String, dynamic> projectData = {
  //       'title': newTitle,
  //       'images': [newImage], // Update the image list as needed
  //       // Include other fields as necessary
  //     };

  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userId)
  //         .collection('projects')
  //         .doc(projectId)
  //         .update(projectData);

  //     // Optionally, you can update your local model to reflect the changes
  //     final index = listeDesProjetsModelObj.userprofileItemList
  //         .indexWhere((item) => item.id == projectId);
  //     if (index != -1) {
  //       listeDesProjetsModelObj.userprofileItemList[index].titreduprojet =
  //           newTitle;
  //       listeDesProjetsModelObj.userprofileItemList[index].circleimage =
  //           newImage;
  //     }

  //     notifyListeners();
  //   } catch (error) {
  //     print('Error updating project: $error');
  //     throw Exception('Failed to update project: $error');
  //   }
  // }

  // Example method to simulate saving data to a database or API
  Future<void> saveToDatabase(
    String title,
    String description,
    String images,
    String budget,
    String duration,
    String comptecourant,
    String currency,
    String category,
    double percentage,
  ) async {
    // This method would be used to interact with a database or API to store the project data
    print('Saving project to database...');
    // Simulate a delay
    await Future.delayed(Duration(seconds: 2));
    print(
        "Project saved: $title, $description, $currency, $category, $percentage");
  }
}
