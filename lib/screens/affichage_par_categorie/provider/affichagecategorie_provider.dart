import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rifund/screens/affichage_par_categorie/models/listtext_item_model.dart';
import '../models/affichagecategorie_model.dart';

class AffichageCategorieProvider extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  List<ListtextItemModel1> filteredProjects = [];
  List<ListtextItemModel1> allProjects = [];
  bool isLoading = false;
  String errorMessage = '';
  String userName = 'Utilisateur';
  String? profileImageUrl;

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
          profileImageUrl = userDoc.get('image_user');

          profileImageUrl ??= await _getProfileImageUrlFromStorage(currentUser.uid);
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

  Future<void> fetchProjectsByCategory(String categoryName) async {
    isLoading = true;
    notifyListeners();

    List<ListtextItemModel1> projects = [];
    try {
      QuerySnapshot projectsSnapshot = await FirebaseFirestore.instance
          .collection('projects')
          .where('category', isEqualTo: categoryName)
          .get();

      for (var projectDoc in projectsSnapshot.docs) {
        projects.add(ListtextItemModel1.fromMap(
          projectDoc.id,
          projectDoc.data() as Map<String, dynamic>,
        ));
      }

      allProjects = projects;
      filteredProjects = allProjects;
    } catch (e) {
      errorMessage = 'Erreur de téléchargement des projets: $e';
      log(errorMessage);
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
