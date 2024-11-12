import 'dart:developer';

class ListtextItemModel1 {
  String? id;
  String? userId;
  String? projectId;
  String? title;
  double? budget;
  List<String>? images;
  String? description;
  String? category;
  double? percentage;

  ListtextItemModel1({
    this.id,
    this.projectId,
    this.title,
    this.userId,
    this.images,
    this.budget,
    this.category,
    this.description,
    this.percentage,
  });

  factory ListtextItemModel1.fromMap(String docId, Map<String, dynamic> data) {
    return ListtextItemModel1(
      id: docId,
      title: data['title'] as String? ?? '',
      budget: _parseDouble(data['budget']),
      projectId: data['projectID'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      description: data['description'] as String? ?? '',
      category: data['category'] as String? ?? '',
      percentage: _parseDouble(data['percentage']),
      images: data['images'] != null
          ? List<String>.from(data['images'] as List)
          : [],
    );
  }

  static double? _parseDouble(dynamic value) {
    try {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        return double.tryParse(value) ?? 0.0;
      }
    } catch (e) {
      log('Error parsing double: $e');
    }
    return 0.0;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'budget': budget,
      'userId': userId,
      'images': images,
      'description': description,
      'category': category,
      'percentage': percentage,
    };
  }
}


class CategoryItemModel1 {
  String? name;
  List<String>? images;

  CategoryItemModel1({
    this.name,
    this.images,
  });

  factory CategoryItemModel1.fromMap(Map<String, dynamic> data) {
    return CategoryItemModel1(
      name: data['name'],
      images:
          data['imageUrls'] != null ? List<String>.from(data['imageUrls']) : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrls': images,
    };
  }

}
