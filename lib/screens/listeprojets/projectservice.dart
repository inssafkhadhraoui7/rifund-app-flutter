import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
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
      String projectId = doc.id; // Get the document ID

      return UserprofileItemModel(
        id: projectId, // Set the ID
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

  
}
