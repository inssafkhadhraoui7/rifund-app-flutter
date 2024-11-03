class SliderItemModel {
  final String imageUrl;
  final String title;
  final String description;
  final double budget;

  SliderItemModel({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.budget,
  });

  factory SliderItemModel.fromJson(Map<String, dynamic> json) {
    return SliderItemModel(
      imageUrl: json['imageUrl'] ?? '',
      title: json['title'] ?? 'No Title',
      description: json['description'] ??
          'No Description', 
      budget: json['budget']?.toDouble() ??
          0.0, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'title': title,
      'description': description,
      'budget': budget,
    };
  }
}
