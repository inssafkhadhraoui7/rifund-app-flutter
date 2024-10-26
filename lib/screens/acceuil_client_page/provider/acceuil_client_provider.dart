import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/acceuil_client_model.dart';
import '../models/listtext_item_model.dart';

class AcceuilClientProvider extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  AcceuilClientModel acceuilClientModelObj = AcceuilClientModel();
  ListeprojectsModel listeprojectsModel = ListeprojectsModel();
  List<ListtextItemModel> filteredProjects = []; // For filtered projects
  bool isLoading = false;
  String errorMessage = '';

  AcceuilClientProvider() {
    // Listen for changes in the search text
    searchController.addListener(_filterProjects);
  }

  Future<void> fetchAllProjects() async {
    isLoading = true;
    notifyListeners();

    List<ListtextItemModel> allProjects = [];
    try {
      // Fetch all users
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      // Loop through each user document
      for (var userDoc in usersSnapshot.docs) {
        // Fetch projects for each user
        QuerySnapshot projectsSnapshot =
            await userDoc.reference.collection('projects').get();

        // Loop through each project document
        for (var projectDoc in projectsSnapshot.docs) {
          allProjects.add(
            ListtextItemModel.fromMap(
                projectDoc.data() as Map<String, dynamic>),
          );
        }
      }

      // Assign the fetched projects to the ListeprojectsModel
      listeprojectsModel.listprojects = allProjects;
      filteredProjects = allProjects;
      errorMessage = ''; // Reset error message on success
    } catch (e) {
      errorMessage = 'Error fetching projects: $e';
      print(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _filterProjects() {
    String query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredProjects = List.from(
          listeprojectsModel.listprojects); // Show all if search is empty
    } else {
      filteredProjects = listeprojectsModel.listprojects.where((project) {
        return project.title != null &&
            project.title!.toLowerCase().contains(query);
      }).toList();
    }
    notifyListeners(); // Notify listeners of the change
  }

  @override
  void dispose() {
    searchController.removeListener(
        _filterProjects); // Remove listener to prevent memory leaks
    searchController.dispose();
    super.dispose();
  }
}
