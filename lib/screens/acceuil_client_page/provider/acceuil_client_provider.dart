import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/acceuil_client_model.dart';
import '../models/listtext_item_model.dart';

class AcceuilClientProvider extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  AcceuilClientModel acceuilClientModelObj = AcceuilClientModel();
  ListeprojectsModel listeprojectsModel = ListeprojectsModel();
  List<ListtextItemModel> filteredProjects = [];
  bool isLoading = false;
  String errorMessage = '';

  AcceuilClientProvider() {
    searchController.addListener(_filterProjects);
  }

  Future<void> fetchAllProjects() async {
    isLoading = true;
    notifyListeners();

    List<ListtextItemModel> allProjects = [];
    try {
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      for (var userDoc in usersSnapshot.docs) {
        QuerySnapshot projectsSnapshot =
            await userDoc.reference.collection('projects').get();

        for (var projectDoc in projectsSnapshot.docs) {
          allProjects.add(
            ListtextItemModel.fromMap(
                projectDoc.data() as Map<String, dynamic>),
          );
        }
      }

      listeprojectsModel.listprojects = allProjects;
      filteredProjects = allProjects;
      errorMessage = '';
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
      filteredProjects = List.from(listeprojectsModel.listprojects);
    } else {
      filteredProjects = listeprojectsModel.listprojects.where((project) {
        return project.title != null &&
            project.title!.toLowerCase().contains(query);
      }).toList();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.removeListener(
        _filterProjects); // Remove listener to prevent memory leaks
    searchController.dispose();
    super.dispose();
  }
}
