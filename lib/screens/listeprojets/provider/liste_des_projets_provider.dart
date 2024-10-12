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
}
