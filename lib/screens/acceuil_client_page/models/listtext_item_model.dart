class ListtextItemModel {
  String? userId;
  String? title;
  // String? description;
  double? budget;
  List<String>? images;

  ListtextItemModel({
    this.title,
    this.userId,
    this.images,
    // this.description,
    this.budget,
  });

  factory ListtextItemModel.fromMap(Map<String, dynamic> data) {
    return ListtextItemModel(
      title: data['title'] as String,
      //  description: data['description'] as String,
      budget: data['budget'],
      userId: data['userId'] as String?, // Ensure userId is fetched
      images: List<String>.from(data['images'] ?? []),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      // 'description': description,
      'budget': budget,
      'userId': userId,
      'images': images,
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
