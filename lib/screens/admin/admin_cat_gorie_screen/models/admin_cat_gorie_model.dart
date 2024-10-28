class AdminCatGorieModel {
  final String id;
  final String name;
  final String? imageUrl;

  AdminCatGorieModel({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory AdminCatGorieModel.fromMap(
      Map<String, dynamic> data, String documentId) {
    return AdminCatGorieModel(
      id: documentId,
      name: data['name'] ?? '',
      imageUrl: (data['imageUrls'] as List<dynamic>?)?.isNotEmpty == true
          ? data['imageUrls'][0]
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrls': imageUrl != null ? [imageUrl!] : [],
    };
  }
}
