import 'package:flutter/material.dart';
import 'package:rifund/screens/listeprojets/models/liste_des_projets_model.dart';
import 'package:rifund/screens/listeprojets/models/userprofile_item_model.dart';
import 'package:rifund/screens/listeprojets/projectservice.dart';

class ListeDesProjetsProvider extends ChangeNotifier {
  ListeDesProjetsModel listeDesProjetsModelObj = ListeDesProjetsModel();

  Future<void> loadUserProjects() async {
    ProjectService projectService = ProjectService();
    try {
      List<UserprofileItemModel> projects =
          await projectService.fetchUserProjects();
      listeDesProjetsModelObj.userprofileItemList = projects;
      notifyListeners();
    } catch (e) {
      print('Error fetching projects: $e');
      // Handle errors as necessary
    }
  }
}
