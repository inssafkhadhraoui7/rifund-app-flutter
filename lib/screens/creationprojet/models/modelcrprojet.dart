import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/models/selectionPopupModel/selection_popup_model.dart';

class CrErProjetModel {
  double percentage;

  List<SelectionPopupModel> dropdownItemList;
  List<SelectionPopupModel> categoryDropdownItemList;

  CrErProjetModel({
    this.percentage = 0.0,
    List<SelectionPopupModel>? dropdownItems,
    List<SelectionPopupModel>? categoryDropdownItems,
  })  : dropdownItemList = dropdownItems ??
            [
              SelectionPopupModel(id: 1, title: "TND", isSelected: true),
              SelectionPopupModel(id: 2, title: "USD"),
              SelectionPopupModel(id: 3, title: "Euro"),
              SelectionPopupModel(id: 4, title: "GBP"),
            ],
        categoryDropdownItemList = categoryDropdownItems ?? [];

 
  Future<void> initCategoryDropdown() async {
    categoryDropdownItemList = await fetchCategories();
    
    if (categoryDropdownItemList.isNotEmpty) {
      categoryDropdownItemList[0].isSelected = true;
    }
  }

 
  Future<List<SelectionPopupModel>> fetchCategories() async {
    List<SelectionPopupModel> categoryList = [];

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('categories').get();

      for (var doc in snapshot.docs) {
        categoryList.add(SelectionPopupModel(
          id: int.parse(doc.id),
          title: doc['title'],
          isSelected: false,
        ));
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }

    return categoryList;
  }

  void selectDropdownItem(int id) {
    for (var item in dropdownItemList) {
      item.isSelected = (item.id == id);
    }
  }

  void selectCategoryItem(int id) {
    for (var item in categoryDropdownItemList) {
      item.isSelected = (item.id == id);
    }
  }
}
