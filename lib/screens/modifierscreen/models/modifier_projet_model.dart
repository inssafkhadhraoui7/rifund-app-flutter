import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';

class ModifierProjetModel {
  double percentage;
  List<SelectionPopupModel> dropdownItemList; // Currency List
  List<SelectionPopupModel> categoryDropdownItemList; // Category List

  ModifierProjetModel({
    this.percentage = 0.0,
    List<SelectionPopupModel>? dropdownItems,
    List<SelectionPopupModel>? categoryDropdownItems,
  })  : dropdownItemList = dropdownItems ?? [
          SelectionPopupModel(id: 1, title: "TND", isSelected: true),
          SelectionPopupModel(id: 2, title: "USD"),
          SelectionPopupModel(id: 3, title: "Euro"),
          SelectionPopupModel(id: 4, title: "GBP"),
        ],
        categoryDropdownItemList = categoryDropdownItems ?? [];

  // Initializes categories from Firestore
  Future<void> initCategoryDropdown() async {
    categoryDropdownItemList = await fetchCategories();
    
    if (categoryDropdownItemList.isNotEmpty) {
      // Automatically select the first item by default
      categoryDropdownItemList[0].isSelected = true;
    }
    print("Categories loaded: $categoryDropdownItemList");
  }

  // Fetches categories from Firestore and maps them to SelectionPopupModel
  Future<List<SelectionPopupModel>> fetchCategories() async {
    List<SelectionPopupModel> categoryList = [];

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('categories').get();

      for (var doc in snapshot.docs) {
        categoryList.add(SelectionPopupModel(
          id: int.parse(doc.id),
          title: doc['name'],
          isSelected: false, // Default: Not selected
        ));
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }

    return categoryList;
  }

  // Selects the currency dropdown item based on the given ID
  void selectDropdownItem(int id) {
    for (var item in dropdownItemList) {
      item.isSelected = (item.id == id); // Set the selected item
    }
  }

  // Selects the category dropdown item based on the given ID
  void selectCategoryItem(int id) {
    for (var item in categoryDropdownItemList) {
      item.isSelected = (item.id == id); // Set the selected item
    }
  }

  // Additional helper method to get the selected currency (for submitting data, etc.)
  String getSelectedCurrency() {
    final selectedItem = dropdownItemList.firstWhere(
      (item) => item.isSelected,
      orElse: () => dropdownItemList.first, // Default to the first item if no selection
    );
    return selectedItem.title;  // Return the currency title (e.g. "USD")
  }

  // Additional helper method to get the selected category (for submitting data, etc.)
  String getSelectedCategory() {
    final selectedItem = categoryDropdownItemList.firstWhere(
      (item) => item.isSelected,
      orElse: () => categoryDropdownItemList.first, // Default to the first item if no selection
    );
    return selectedItem.title;  // Return the category title (e.g. "Design")
  }
}
