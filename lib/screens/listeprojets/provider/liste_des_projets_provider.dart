import 'package:cross_file/src/types/interface.dart';
import 'package:flutter/material.dart';
import 'package:rifund/screens/listeprojets/models/liste_des_projets_model.dart';
import 'package:rifund/screens/listeprojets/projectservice.dart';

class ListeDesProjetsProvider extends ChangeNotifier {
  ListeDesProjetsModel listeDesProjetsModelObj = ListeDesProjetsModel();

  Future<void> loadUserProjects() async {
    try {
      ProjectService projectService = ProjectService();
      listeDesProjetsModelObj.userprofileItemList =
          await projectService.fetchUserProjects();
      notifyListeners();
      
    } catch (e) {
      print('Error loading projects: $e');
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      await ProjectService().deleteUserProject(projectId); 
      // Remove from local list as well
      listeDesProjetsModelObj.userprofileItemList.removeWhere((item) => item.id == projectId);
      notifyListeners();
    } catch (e) {
      print('Erreur de suppression du projet $e');
    }
  }

  updateProject(String? id, String newName, String newDescription, XFile? selectedImage) {}
}
