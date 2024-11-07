class SliderItemModel {
  // final String userId;
  // final String projetId;
  final String imageUrl;
  final String title;
  final String description;
  final double budget;

  SliderItemModel({
    // required this.userId,
    // required this.projetId,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.budget,
  });

  factory SliderItemModel.fromJson(Map<String, dynamic> json) {
    return SliderItemModel(
      // userId: json['userId'],
      // projetId: json['projetId'],
      imageUrl: json['imageUrl'] ?? '',
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      budget: (json['budget'] != null && json['budget'] is num)
          ? (json['budget'] as num).toDouble()
          : 0.0,
    );
  }

  // Convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      // 'userId': userId,
      // 'projetId': projetId,
      'imageUrl': imageUrl,
      'title': title,
      'description': description,
      'budget': budget,
    };
  }
}
