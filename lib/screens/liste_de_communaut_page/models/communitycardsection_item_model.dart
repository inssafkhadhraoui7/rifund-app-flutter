class CommunitycardsectionItemModel {
  final String name;
  final String description;
  final String imageUrl;

  CommunitycardsectionItemModel({
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory CommunitycardsectionItemModel.fromFirestore(Map<String, dynamic> data) {
    return CommunitycardsectionItemModel(
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',  // Use this if imageUrl is stored in Firestore
    );
  }
}
