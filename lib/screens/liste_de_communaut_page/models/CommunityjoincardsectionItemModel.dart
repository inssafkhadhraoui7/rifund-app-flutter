import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityjoincardsectionItemModel {
  final String communityId; // Add this line to define communityId
  final String name;
  final String description;
  final String imageUrl;
  final String projectId;
  final String userId;

  CommunityjoincardsectionItemModel({
    required this.communityId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.projectId,
    required this.userId,
  });
  factory CommunityjoincardsectionItemModel.fromFirestore(
      DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return CommunityjoincardsectionItemModel(
      communityId: data['communityId'],
      name: data['name'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      projectId: data['projectId'],
      userId: data['userId'],
    );
  }
}
