class ListtextItemModel {
  String? userId;
  String? projectId;
  String? title;
  double? budget;
  List<String>? images;
  String? description;
  String? category;
  double? percentage;

  ListtextItemModel({
    this.projectId,
    this.title,
    this.userId,
    this.images,
    this.budget,
    this.category,
    this.description,
    this.percentage,
  });

  factory ListtextItemModel.fromMap(Map<String, dynamic> data) {
    return ListtextItemModel(
      title: data['title'] as String,
      budget: data['budget'],
      projectId: data['projectID'] as String?,
      userId: data['userId'] as String?,
      description: data['description'],
      category: data['category'],
      percentage: data['percentage'],
      images: List<String>.from(data['images'] ?? []),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'budget': budget,
      'userId': userId,
      'images': images,
      'description':description,
      'category':category,
      'percentage':percentage,
    };
  }
}

class CategoryItemModel {
  String? title;
  String? images;

  CategoryItemModel({
    this.title,
    this.images,
  });

  factory CategoryItemModel.fromMap(Map<String, dynamic> data) {
    return CategoryItemModel(
      title: data['title'],
      images: data['image'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': images,
    };
  }
}
