class ListtextItemModel {
  String? title;
  // String? description;
  // String? budget;

  ListtextItemModel({
    this.title,
    //this.images,
    // this.description,
    // this.budget,
  });

  factory ListtextItemModel.fromMap(Map<String, dynamic> data) {
    return ListtextItemModel(
      title: data['title'] as String,
      //  description: data['description'] as String,
      // budget: data['budget'] as String,
      //images: data['images'] as String, 
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      // 'description': description,
      // 'budget': budget,
      //'images': images,
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
