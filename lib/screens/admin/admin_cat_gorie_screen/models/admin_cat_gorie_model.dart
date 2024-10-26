class AdminCatGorieModel {
  final String id; // Unique identifier for the category
  final String name;
  final String? imageUrl; // Make imageUrl nullable

  AdminCatGorieModel({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory AdminCatGorieModel.fromMap(
      Map<String, dynamic> data, String documentId) {
    return AdminCatGorieModel(
      id: documentId, // Pass the document ID
      name: data['name'] ?? '',
      imageUrl: (data['imageUrls'] as List<dynamic>?)?.isNotEmpty == true
          ? data['imageUrls'][0] // Get the first URL if it exists
          : null, // Return null if no URL exists
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrls':
          imageUrl != null ? [imageUrl!] : [], // Store as a list, empty if null
    };
  }
}
