import '../../../core/app_export.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart'; // ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class CrErProjetModel {
  List<SelectionPopupModel> dropdownItemList = [
    SelectionPopupModel(
      id: 1,
      title: "TND",
      isSelected: true,
    ),
    SelectionPopupModel(
      id: 2,
      title: "USD",
    ),
    SelectionPopupModel(
      id: 3,
      title: "Euro",
    ),
    SelectionPopupModel(
      id: 3,
      title: "GBP",
    )
  ];

  List<SelectionPopupModel> dropdownItemList1 = [
    SelectionPopupModel(
      id: 1,
      title: "Item One",
      isSelected: true,
    ),
    SelectionPopupModel(
      id: 2,
      title: "Item Two",
    ),
    SelectionPopupModel(
      id: 3,
      title: "Item Three",
    )
  ];
}
