import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rifund/screens/listeprojets/models/liste_des_projets_model.dart';
import 'package:rifund/screens/listeprojets/projectservice.dart';

class ListeDesProjetsProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ListeDesProjetsModel listeDesProjetsModelObj = ListeDesProjetsModel();

  Future<void> loadUserProjects() async {
    try {
      ProjectService projectService = ProjectService();
      listeDesProjetsModelObj.userprofileItemList =
          await projectService.fetchUserProjects();
      notifyListeners();
    } catch (e) {
      print('Erreur de chargement projet: $e');
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      await ProjectService().deleteUserProject(projectId);
      // Remove from local list as well
      listeDesProjetsModelObj.userprofileItemList
          .removeWhere((item) => item.id == projectId);
      notifyListeners();
    } catch (e) {
      print('Erreur de suppression du projet $e');
    }
  }
}
