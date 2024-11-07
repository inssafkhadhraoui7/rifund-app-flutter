import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  String userName = 'Utilisateur'; // Default value
  String? profileImageUrl; 

  AcceuilClientProvider() {
    searchController.addListener(_filterProjects);
       fetchUserData(); // Call fetchUserData in the constructor
  }

  Future<void> fetchUserData() async {
    isLoading = true;
    notifyListeners();

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          userName = userDoc.get('nom') ?? 'Utilisateur';
          profileImageUrl = userDoc.get('profileImageUrl');

          // Get the profile image from Firebase Storage if not available in Firestore
          if (profileImageUrl == null) {
            profileImageUrl = await _getProfileImageUrlFromStorage(currentUser.uid);
          }
        }
      }
      errorMessage = '';
    } catch (e) {
      errorMessage = 'Erreur de téléchargement de l\'utilisateur: $e';
      log(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> _getProfileImageUrlFromStorage(String uid) async {
    try {
      final ref = FirebaseStorage.instance.ref().child("users_images/$uid/");
      return await ref.getDownloadURL();
    } catch (e) {
      log('Erreur lors de la récupération de l\'image: $e');
      return null;
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
              projectDoc.id,
              projectDoc.data() as Map<String, dynamic>,
            ),
          );
        }
      }

      listeprojectsModel.listprojects = allProjects;
      filteredProjects = allProjects;
      errorMessage = '';
    } catch (e) {
      errorMessage = 'Erreur de telechargement de projets $e';
      log(errorMessage);
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
      errorMessage = 'Erreur de téléchargement des catégories : $e';
      log(errorMessage);
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