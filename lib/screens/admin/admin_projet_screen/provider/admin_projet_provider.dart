import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/admin_projet_model.dart';

class AdminProjetProvider extends ChangeNotifier {
  AdminProjetModel adminProjetModelObj = AdminProjetModel();
  List<AdminProjetModel> projects = [];
  bool isLoading = false;
  String errorMessage = '';

  Future<void> fetchProjects() async {
    isLoading = true;
    notifyListeners();

    List<AdminProjetModel> allProjects = [];
    try {
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      print('Fetched users: ${usersSnapshot.docs.length}');

      for (var userDoc in usersSnapshot.docs) {
        QuerySnapshot projectsSnapshot =
            await userDoc.reference.collection('projects').get();
        print(
            'Fetched projects for user ${userDoc.id}: ${projectsSnapshot.docs.length}');

        for (var projectDoc in projectsSnapshot.docs) {
          allProjects.add(
            AdminProjetModel.fromMap(projectDoc.data() as Map<String, dynamic>),
          );
        }
      }

      projects = allProjects;
      print('Tout les projets téléchargés ${projects.length}');
      errorMessage = '';
    } catch (e) {
      errorMessage = 'Erreur de télechargement des projets $e';
      print(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
