class CommunitycardsectionItemModel {
  final String communityId; // Community ID
  final String projectId; // Project ID associated with this community
  final String name;
  final String description;
  final String imageUrl;
  final String projectName;

  CommunitycardsectionItemModel({
    required this.communityId,
    required this.projectId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.projectName,
  });

factory CommunitycardsectionItemModel.fromFirestore(
    Map<String, dynamic> data, String projectName, String communityId, String projectId) {
  return CommunitycardsectionItemModel(
    communityId: communityId,  // Set communityId to documentId correctly
    projectId: projectId,      // Set projectId to the actual project ID
    name: data['name'] ?? 'Unknown Community',
    description: data['description'] ?? 'No description available.',
    imageUrl: data['webUrl'] ?? '',
    projectName: projectName,
  );
}

}
