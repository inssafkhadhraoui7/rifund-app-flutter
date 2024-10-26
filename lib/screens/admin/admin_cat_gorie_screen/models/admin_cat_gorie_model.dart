class AdminCatGorieModel {
  final String name;
  final String imageUrl;

  AdminCatGorieModel({required this.name, required this.imageUrl});

  factory AdminCatGorieModel.fromMap(Map<String, dynamic> data) {
    return AdminCatGorieModel(
      name: data['name'] ?? '',
      imageUrl: (data['imageUrls'] as List<dynamic>?)?.isNotEmpty == true
          ? data['imageUrls'][0] // Get the first URL if it exists
          : '', // Handle empty case
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrls': [imageUrl], // Store as a list
    };
  }
}
