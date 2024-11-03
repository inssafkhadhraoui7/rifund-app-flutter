class AdminCategoryModel {
  final String id;
  final String name;
  final String? imageUrl;

  AdminCategoryModel({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory AdminCategoryModel.fromMap(
      Map<String, dynamic> data, String documentId) {
    return AdminCategoryModel(
      id: documentId,
      name: data['name'] ?? '',
      imageUrl: _getImageUrl(
          data['imageUrls']), // Use the helper function to get the image URL
    );
  }

  static String? _getImageUrl(dynamic imageUrls) {
    if (imageUrls is List) {
      return imageUrls.isNotEmpty ? imageUrls[0] as String : null;
    } else if (imageUrls is String) {
      return imageUrls;
    }
    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrls': imageUrl != null ? [imageUrl!] : [],
    };
  }
}
