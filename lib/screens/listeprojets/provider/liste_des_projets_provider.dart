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

  Future<void> updateProject(
      String projectId, String newTitle, String newImage) async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        throw Exception("User is not authenticated");
      }

      Map<String, dynamic> projectData = {
        'title': newTitle,
        'images': [newImage], // Update the image list as needed
        // Include other fields as necessary
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('projects')
          .doc(projectId)
          .update(projectData);

      // Optionally, you can update your local model to reflect the changes
      final index = listeDesProjetsModelObj.userprofileItemList
          .indexWhere((item) => item.id == projectId);
      if (index != -1) {
        listeDesProjetsModelObj.userprofileItemList[index].titreduprojet =
            newTitle;
        listeDesProjetsModelObj.userprofileItemList[index].circleimage =
            newImage;
      }

      notifyListeners();
    } catch (error) {
      print('Error updating project: $error');
      throw Exception('Failed to update project: $error');
    }
  }
}
