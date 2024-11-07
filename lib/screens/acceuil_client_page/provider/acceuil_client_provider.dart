import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String userName = '';
  String errorMessage = '';

  AcceuilClientProvider() {
    searchController.addListener(_filterProjects);
  }
  Future<void> fetchUserData() async {
    isLoading = true;
    notifyListeners();

    try {
      // Assume we are getting the current user using FirebaseAuth
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          userName = userDoc['nom'] ?? 'Utilisateur';
        }
      }
      errorMessage = '';
    } catch (e) {
      errorMessage = 'Erreur de téléchargement de l\'utilisateur $e';
      print(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
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

        for (var projectDoc in projectsSnapshot.docs) {
          allProjects.add(
            ListtextItemModel.fromMap(
              projectDoc.data() as Map<String, dynamic>,
            ),
          );
        }
      }

      listeprojectsModel.listprojects = allProjects;
      filteredProjects = allProjects;
      errorMessage = '';
    } catch (e) {
      errorMessage = 'Erreur de téléchargement de projets $e';
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

      listcategoryItemList = allCategories;
    } catch (e) {
      print('Erreur de téléchargement des catégories : $e');
      errorMessage = 'Erreur de téléchargement des catégories : $e';
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
    searchController.removeListener(_filterProjects);
    searchController.dispose();
    super.dispose();
  }
}
