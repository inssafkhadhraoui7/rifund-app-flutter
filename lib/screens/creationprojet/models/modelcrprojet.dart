import '../../../data/models/selectionPopupModel/selection_popup_model.dart';

class CrErProjetModel {
  List<SelectionPopupModel> dropdownItemList = [
    SelectionPopupModel(id: 1, title: "TND", isSelected: true),
    SelectionPopupModel(id: 2, title: "USD"),
    SelectionPopupModel(id: 3, title: "Euro"),
    SelectionPopupModel(id: 4, title: "GBP"),
  ];

  List<SelectionPopupModel> categoryDropdownItemList = [
    SelectionPopupModel(id: 1, title: "Social", isSelected: true),
    SelectionPopupModel(id: 2, title: "Economie"),
    SelectionPopupModel(id: 3, title: "Technologie"),
  ];

  void selectDropdownItem(int id) {
    for (var item in dropdownItemList) {
      item.isSelected = item.id == id; 
    }
  }

  void selectCategoryItem(int id) {
    for (var item in categoryDropdownItemList) {
      item.isSelected = item.id == id; 
    }
  }
}
