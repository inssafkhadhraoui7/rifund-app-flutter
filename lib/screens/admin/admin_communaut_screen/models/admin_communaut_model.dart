import 'package:cloud_firestore/cloud_firestore.dart';

class AdminCommunautModel {
  final String id;
  final String name;
  final String description;
  final String webUrl;
  final String userId;
  final String projectId;
  final DateTime createdAt; // New field for creation date

  AdminCommunautModel({
    required this.id,
    required this.name,
    required this.description,
    required this.webUrl,
    required this.userId,
    required this.projectId,
    required this.createdAt, // Initialize createdAt
  });

  // Create a factory constructor to handle Firestore snapshot and missing fields
  factory AdminCommunautModel.fromDocument(DocumentSnapshot doc) {
    // Print the entire document data to debug
    print('Document data: ${doc.data()}');

    // Safely cast data to Map<String, dynamic> for key checks
    final data = doc.data() as Map<String, dynamic>;

    // If 'createdAt' field is present and of type Timestamp, convert it to DateTime
    final createdAt = (data['createdAt'] is Timestamp)
        ? (data['createdAt'] as Timestamp).toDate()
        : DateTime.now(); // Fallback to current time if not available

    return AdminCommunautModel(
      id: doc.id,
      name: data['name'] ?? 'No name', // Default to 'No name' if field is missing
      description: data['description'] ?? 'No description available', // Handle missing 'description'
      webUrl: data['webUrl'] ?? 'No website available', // Handle missing 'webUrl'
      userId: data['userId'] ?? '', // Handle missing 'userId'
      projectId: data['projectId'] ?? '', // Handle missing 'projectId'
      createdAt: createdAt, // Add the converted creation date
    );
  }
}
