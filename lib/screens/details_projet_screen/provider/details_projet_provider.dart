import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import '../models/slider_item_model.dart';

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
