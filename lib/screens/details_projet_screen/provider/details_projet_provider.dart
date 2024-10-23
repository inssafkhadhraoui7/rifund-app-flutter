import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/details_projet_model.dart';
import '../models/slider_item_model.dart';

class DetailsProjetProvider extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();

  DetailsProjetModel detailsProjetModelObj = DetailsProjetModel();

  int sliderIndex = 0;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }
}
