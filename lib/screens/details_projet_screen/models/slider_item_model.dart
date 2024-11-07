class SliderItemModel {
  final String imageUrl;
  final String title; // New field for title
  final String description; // New field for description
  final double budget; // New field for budget

  SliderItemModel({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.budget,
  });

  // Factory constructor to create an instance from JSON
  factory SliderItemModel.fromJson(Map<String, dynamic> json) {
    return SliderItemModel(
      imageUrl: json['imageUrl'] ?? '',
      title: json['title'] ?? 'No Title', // Default value if title is missing
      description: json['description'] ?? 'No Description', // Default value if description is missing
      budget: json['budget']?.toDouble() ?? 0.0, // Convert to double and default to 0.0
    );
  }

  // Convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'title': title,
      'description': description,
      'budget': budget,
    };
  }
}
