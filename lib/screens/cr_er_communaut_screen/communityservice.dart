import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityServiceException implements Exception {
  final String message;
  CommunityServiceException(this.message);

  @override
  String toString() => 'CommunityServiceException: $message';
}

class CommunityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> createCommunity({
    required String name,
    required String description,
    String? webUrl,
    required String projectId,
  }) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('communities').add({
        'name': name,
        'description': description,
        if (webUrl != null) 'webUrl': webUrl,
        'projectId': projectId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('La creation du communauté se fait correctement ${docRef.id}');
      return docRef.id; 
    } catch (e) {
      print('La creation communauté est echoué $e');
      throw CommunityServiceException('Error creating community: $e');
    }
  }
}
