import '../../../data/models/selectionPopupModel/selection_popup_model.dart';

class CrErProjetModel {
  double percentage;

  List<SelectionPopupModel> dropdownItemList;
  List<SelectionPopupModel> categoryDropdownItemList;

  CrErProjetModel({
    this.percentage = 0.0,
    List<SelectionPopupModel>? dropdownItems,
    List<SelectionPopupModel>? categoryDropdownItems,
  })  : dropdownItemList = dropdownItems ?? [
          SelectionPopupModel(id: 1, title: "TND", isSelected: true),
          SelectionPopupModel(id: 2, title: "USD"),
          SelectionPopupModel(id: 3, title: "Euro"),
          SelectionPopupModel(id: 4, title: "GBP"),
        ],
        categoryDropdownItemList = categoryDropdownItems ?? [
          SelectionPopupModel(id: 1, title: "Social", isSelected: true),
          SelectionPopupModel(id: 2, title: "Economie"),
          SelectionPopupModel(id: 3, title: "Technologie"),
        ];

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
