import 'package:cloud_firestore/cloud_firestore.dart';

class AdminProjetModel {
  String? title;
  String? description;
  DateTime? date;
  String? category;
  double? budget;
  List<String>? images;

  AdminProjetModel({
    this.title,
    this.description,
    this.date,
    this.category,
    this.budget,
    this.images,
  });

  factory AdminProjetModel.fromMap(Map<String, dynamic> data) {
    print(data);
    return AdminProjetModel(
      title: data['title'] as String?,
      description: data['description'] as String?,
      date: (data['date'] as Timestamp?)?.toDate(),
      category: data['category'] as String?,
      budget: (data['budget'] as num?)?.toDouble(),
      images: List<String>.from(data['images'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date != null ? Timestamp.fromDate(date!) : null,
      'category': category,
      'budget': budget,
      'images': images,
    };
  }

  @override
  String toString() {
    return 'AdminProjetModel(title: $title, description: $description, date: $date, category: $category, budget: $budget, images: $images)';
  }
}
