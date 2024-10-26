import 'package:cloud_firestore/cloud_firestore.dart';
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
      print('Error loading projects: $e');
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      // Reference to the project document
      DocumentReference projectRef =
          _firestore.collection('projects').doc(projectId);

      // Start a Firestore batch
      WriteBatch batch = _firestore.batch();
      QuerySnapshot communitiesSnapshot =
          await projectRef.collection('communities').get();

      // Add the project document deletion to the batch
      batch.delete(projectRef);
      print('le projet est en cours de suppression: $projectId');

      // Check if there are any communities to delete
      print(
          'Number of communities to delete: ${communitiesSnapshot.docs.length}');

      // Add each document in the communities sub-collection to the batch for deletion
      for (QueryDocumentSnapshot doc in communitiesSnapshot.docs) {
        batch.delete(doc.reference);
        print('Preparing to delete community: ${doc.id}');
      }

      // Commit the batch
      await batch.commit();
      print('le projet est supprimé');

      // Remove from local list
      listeDesProjetsModelObj.userprofileItemList
          .removeWhere((item) => item.id == projectId);
      notifyListeners();
    } catch (e) {
      print('Error deleting project: $e');
      // Log additional information if needed
    }
  }
}
