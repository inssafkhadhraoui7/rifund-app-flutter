import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rifund/core/app_export.dart';
import 'package:rifund/screens/listeprojets/models/userprofile_item_model.dart';

class ProjectService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserprofileItemModel>> fetchUserProjects() async {
    String? userId = _auth.currentUser?.uid;

    if (userId == null) {
      throw Exception('Il faut être connecté');
    }

    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('projects')
        .get();

    List<UserprofileItemModel> projects = snapshot.docs.map((doc) {
      String title = doc['title'] ?? 'Pas de titre';
      List<String> images = List<String>.from(doc['images'] ?? []);
      String projectId = doc.id;

      return UserprofileItemModel(
        id: projectId,
        titreduprojet: title,
        circleimage: images.isNotEmpty ? images[0] : ImageConstant.imgprofile,
        // Uncomment if financing percentage is available
        // seventy: '${(doc['financedPercentage'] ?? 0.0 * 100).toStringAsFixed(0)} %',
      );
    }).toList();

    print('Fetched projects: ${projects.length}');

    return projects;
  }

  Future<void> deleteUserProject(String projectId) async {
    String? userId = _auth.currentUser?.uid;

    if (userId == null) {
      throw Exception('Il faut être connecté');
    }

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('projects')
        .doc(projectId)
        .delete();

    print('Project $projectId deleted');
  }

  Future<Map<String, dynamic>?> fetchProjectById(String projectId) async {
    String? userId = _auth.currentUser?.uid;

    if (userId == null) {
      throw Exception('Il faut être connecté');
    }

    DocumentSnapshot doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('projects')
        .doc(projectId)
        .get();

    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    } else {
      print('No project found for ID: $projectId');
      return null;
    }
  }
  Future<void> updateUserProject(String projectId, String title, String image) async {
    String? userId = _auth.currentUser?.uid;

    if (userId == null) {
      throw Exception('User must be logged in');
    }

    // Reference to the specific project document
    DocumentReference projectRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('projects')
        .doc(projectId);

    // Update the project with the new values
    await projectRef.update({
      'title': title,
      'images': [image], // You can handle multiple images as needed
    });

    print('Project updated: $projectId');
  }
}
