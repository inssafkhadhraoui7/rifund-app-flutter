class Community {
  final String id;          // Unique identifier for the community
  final String name;        // Name of the community
  final String description; // Description of the community
  final String imageUrl;    // URL of the community's image

  // Constructor
  Community({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  // Factory method to create an instance from a map (e.g., from Firestore)
  factory Community.fromMap(Map<String, dynamic> data, String communityId) {
    return Community(
      id: communityId,
      name: data['name'] ?? 'Unknown Community',
      description: data['description'] ?? 'No description available',
      imageUrl: data['imageUrl'] ?? '', // Assuming imageUrl is stored in Firestore
    );
  }

  // Method to convert an instance to a map (if needed for Firestore or API)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
