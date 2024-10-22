import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/acceuil_client_model.dart';
import '../models/listtext_item_model.dart';

class AcceuilClientProvider extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  AcceuilClientModel acceuilClientModelObj = AcceuilClientModel();
  ListeprojectsModel listeprojectsModel =
      ListeprojectsModel(); // Add this instance
  bool isLoading = false;
  String errorMessage = '';

  Future<void> fetchAllProjects() async {
    isLoading = true;
    notifyListeners();

    List<ListtextItemModel> allProjects = [];
    try {
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      for (var userDoc in usersSnapshot.docs) {
        // Get projects for each user
        QuerySnapshot projectsSnapshot =
            await userDoc.reference.collection('projects').get();

        for (var projectDoc in projectsSnapshot.docs) {
          allProjects.add(
            ListtextItemModel.fromMap({
              ...projectDoc.data() as Map<String, dynamic>,
            }),
          );
        }
      }

      // Assign the fetched projects to the ListeprojectsModel
      listeprojectsModel.listprojects =
          allProjects; // Correctly assigning the projects
      errorMessage = '';
    } catch (e) {
      errorMessage = 'Error fetching projects: $e';
      print(errorMessage);
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
