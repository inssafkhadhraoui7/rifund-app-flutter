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
            AdminProjetModel.fromMap({
              ...projectDoc.data() as Map<String, dynamic>,
              'userId': userDoc.id, // Set userId from the user document
              'projectId': projectDoc.id, // Set projectId
            }),
          );
        }
      }

      projects = allProjects;
      print('Total projects downloaded: ${projects.length}');
      errorMessage = '';
    } catch (e) {
      errorMessage = 'Error downloading projects: $e';
      print(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> approveProject(AdminProjetModel project) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(project.userId) // Correctly use the userId from the project
          .collection('projects')
          .doc(project.projectId) // Correctly use the projectId from the project
          .update({'isApproved': true});

      // Send notification
      await sendNotification(project.title!,
          'Le projet nommé "${project.title}" que vous avez créé est accepté.');
      notifyListeners();
    } catch (e) {
      print('Error approving project: $e');
      // Handle errors appropriately
    }
  }

  Future<void> rejectProject(AdminProjetModel project) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(project.userId) // Correctly use the userId from the project
          .collection('projects')
          .doc(project.projectId) // Correctly use the projectId from the project
          .delete();

      await sendNotification(project.title!,
          'Le projet nommé "${project.title}" que vous avez créé n\'est pas accepté.');

      notifyListeners();
    } catch (e) {
      print('Error rejecting project: $e');
      // Handle errors appropriately
    }
  }

  Future<void> sendNotification(String title, String message) async {
    // Implement your notification sending logic here
    // This could be via a push notification service or email
  }

  @override
  void dispose() {
    super.dispose();
  }
}
