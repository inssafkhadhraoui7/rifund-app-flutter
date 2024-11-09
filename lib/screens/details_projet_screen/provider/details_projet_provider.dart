
import 'package:flutter/material.dart';

class DetailsProjetProvider extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  // DetailsProjetModel detailsProjetModelObj = DetailsProjetModel();
  int sliderIndex = 0;
   
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
