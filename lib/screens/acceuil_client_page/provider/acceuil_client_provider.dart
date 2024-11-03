import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/acceuil_client_model.dart';
import '../models/listtext_item_model.dart';

class AcceuilClientProvider extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  AcceuilClientModel acceuilClientModelObj = AcceuilClientModel();
  ListeprojectsModel listeprojectsModel = ListeprojectsModel();
  List<ListtextItemModel> filteredProjects = [];
  List<CategoryItemModel> listcategoryItemList = [];
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
        QuerySnapshot projectsSnapshot = await userDoc.reference
            .collection('projects')
            .where('isApproved', isEqualTo: true)
            .get();

        print(
            'Fetched ${projectsSnapshot.docs.length} approved projects for user ${userDoc.id}');

        for (var projectDoc in projectsSnapshot.docs) {
          allProjects.add(
            ListtextItemModel.fromMap(
                projectDoc.data() as Map<String, dynamic>),
          );

          print('Project: ${projectDoc.data()}'); 
        }
      }

      listeprojectsModel.listprojects = allProjects;
      filteredProjects = allProjects;
      errorMessage = '';
    } catch (e) {
      errorMessage = 'Erreur de telechargement de projets $e';
      print(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCategories() async {
    isLoading = true;
    notifyListeners();
    List<CategoryItemModel> allCategories = [];

    try {
      QuerySnapshot categoriesSnapshot =
          await FirebaseFirestore.instance.collection('categories').get();

      allCategories = categoriesSnapshot.docs.map((doc) {
        return CategoryItemModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Erreur de téléchargement : $e');
    } finally {
      isLoading = false;
      notifyListeners();

      ListcategoriesModel listcategoryItemList =
          ListcategoriesModel(categories: allCategories);
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
    searchController.removeListener(_filterProjects);
    searchController.dispose();
    super.dispose();
  }
}
