import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/slider_item_model.dart';

class DetailsProjetProvider extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  int sliderIndex = 0;
  SliderItemModel? projectDetails;
  bool isLoading = false;
  String errorMessage = '';

  Future<void> fetchProjectDetails(String projectId) async {
    isLoading = true;
    notifyListeners();

    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('projects')
          .doc(projectId)
          .get();

      print(projectId);

      if (docSnapshot.exists) {
        projectDetails = SliderItemModel.fromJson(
            docSnapshot.data() as Map<String, dynamic>);
      } else {
        errorMessage = "le projet n'existe pas.";
      }
    } catch (e) {
      errorMessage = 'Erreur de telechargement du details du projet: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
