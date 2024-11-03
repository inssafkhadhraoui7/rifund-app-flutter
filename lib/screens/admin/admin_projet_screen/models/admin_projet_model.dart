import 'package:cloud_firestore/cloud_firestore.dart';

class AdminProjetModel {
  String? userId;
  String? projectId;
  String? title;
  String? description;
  DateTime? date;
  String? category;
  double? budget;
  List<String>? images;
  bool isApproved;

  AdminProjetModel({
    this.userId,
    this.projectId,
    this.title,
    this.description,
    this.date,
    this.category,
    this.budget,
    this.images,
    this.isApproved = false,
  });

  factory AdminProjetModel.fromMap(Map<String, dynamic> data) {
    print(data);
    return AdminProjetModel(
      userId: data['userId'] as String?,
      projectId: data['projectId'] as String?, 
      title: data['title'] as String?,
      description: data['description'] as String?,
      date: (data['date'] as Timestamp?)?.toDate(),
      category: data['category'] as String?,
      budget: (data['budget'] as num?)?.toDouble(),
      images: List<String>.from(data['images'] ?? []),
      isApproved: data['isApproved'] as bool? ?? false, 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId, 
      'projectId': projectId,
      'title': title,
      'description': description,
      'date': date != null ? Timestamp.fromDate(date!) : null,
      'category': category,
      'budget': budget,
      'images': images,
      'isApproved': isApproved, 
    };
  }

  @override
  String toString() {
    return 'AdminProjetModel(userId: $userId, projectId: $projectId, title: $title, description: $description, date: $date, category: $category, budget: $budget, images: $images, isApproved: $isApproved)';
  }
}
