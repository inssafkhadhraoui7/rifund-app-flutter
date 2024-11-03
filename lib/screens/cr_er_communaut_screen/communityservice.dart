import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createCommunity({
    required String name,
    required String description,
    String? webUrl,
    required String userId,
    required String projectId, // Required project ID
  }) async {
    try {
      if (projectId.isEmpty) {
        throw Exception('Project ID must not be empty.');
      }

      // Create a reference to the user's specific project collection
      DocumentReference projectRef = _firestore
          .collection('users') // Reference to the 'users' collection
          .doc(userId) // Reference to the user document
          .collection('projects') // Reference to the 'projects' sub-collection
          .doc(projectId); // Reference to the specific project document

      // Check if a community already exists for this project
      QuerySnapshot existingCommunities = await projectRef.collection('communities').get();
      if (existingCommunities.docs.isNotEmpty) {
        throw Exception('Une communauté existe déjà pour ce projet. Chaque projet ne peut avoir qu \'une seule communauté.');
      }

      // Add the community document under the specific project's subcollection
      await projectRef.collection('communities').add({
        'name': name,
        'description': description,
        'webUrl': webUrl,
        'userId': userId,
        'projectId': projectId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Update the user's document to add the role 'createur'
      await _firestore.collection('users').doc(userId).set({
        'role': 'createur',
      }, SetOptions(merge: true)); // Use merge to avoid overwriting existing fields

      print('Communauté créée avec succès sous lID utilisateur: $userId, project ID: $projectId');
      
    } catch (e) {
      throw Exception('Erreur lors de la création de la communauté: $e');
    }
  }
}
