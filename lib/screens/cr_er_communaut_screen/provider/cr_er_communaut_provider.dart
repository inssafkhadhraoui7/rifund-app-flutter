import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

<<<<<<< HEAD
class CrErCommunautProvider with ChangeNotifier {
   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers for the input fields
  final TextEditingController createCommunityController = TextEditingController();
  final TextEditingController descriptionValueController = TextEditingController();
  final TextEditingController webUrlController = TextEditingController();

  // Getter to access loading state
  bool get isLoading => _isLoading;

  List<String> selectedImagePaths = [];
  List<String> selectedImageNames = [];

  void updateSelectedImages(List<String> paths, List<String> names) {
    selectedImagePaths = paths;
    selectedImageNames = names;
    notifyListeners();
=======
import '../communityservice.dart';

class CrErCommunautProvider extends ChangeNotifier {
  TextEditingController createCommunityController = TextEditingController();
  TextEditingController descriptionValueController = TextEditingController();
  TextEditingController webUrlController = TextEditingController();

  String? projectId;

  void setProjectId(String id) {
    projectId = id;
  }

  Future<void> createCommunity(BuildContext context) async {
    if (createCommunityController.text.isEmpty ||
        descriptionValueController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please fill in all fields.')));
      return;
    }

    try {
      String communityId = await CommunityService().createCommunity(
        name: createCommunityController.text,
        description: descriptionValueController.text,
        webUrl: webUrlController.text.isEmpty ? null : webUrlController.text,
        projectId: projectId!,
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Community created successfully with ID: $communityId')));

      // Clear fields if needed
      createCommunityController.clear();
      descriptionValueController.clear();
      webUrlController.clear();

      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
>>>>>>> ahmed
  }

  Future<List<String>> uploadImages(List<String> imagePaths) async {
    List<String> imageUrls = [];
    FirebaseStorage storage = FirebaseStorage.instance;
    
    // Get the current user's ID
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      throw Exception('User is not authenticated');
    }

    for (String path in imagePaths) {
      File file = File(path);
      try {
        // Create a unique name for the image under the user's ID
        String fileName = 'users/$userId/images/${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';

        // Upload the file
        TaskSnapshot snapshot = await storage.ref(fileName).putFile(file);

        // Get the download URL
        String downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      } catch (e) {
        print('Error uploading image: $e'); // Consider better error handling
      }
    }
    return imageUrls;
  }

  bool isImageSelectionValid() {
    return selectedImagePaths.length >= 1 && selectedImagePaths.length <= 5;
  }

  // Method to create a community

  // Method to update loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Optionally, implement a dispose method to clean up controllers
  void dispose() {
    createCommunityController.dispose();
    descriptionValueController.dispose();
    webUrlController.dispose();
    super.dispose();
<<<<<<< HEAD
  }
  Future<void> createCommunity(String userId, String projectId, String communityName) async {
  _setLoading(true);
  try {
    // Validate input fields
    if (communityName.isEmpty) {
      throw Exception('Community name is required.');
    }
    if (descriptionValueController.text.isEmpty) {
      throw Exception('Description is required.');
    }
    if (webUrlController.text.isEmpty) {
      throw Exception('URL is required.');
    }

    // Create a community object with user and project references
    final communityData = {
      'name': communityName, // Use the passed communityName
      'description': descriptionValueController.text,
      'url': webUrlController.text,
      'createdAt': FieldValue.serverTimestamp(),
      'userId': userId,          // Reference to the user who created the community
      'projectId': projectId,    // Reference to the associated project
    };

    // Reference to the user's project document
    final projectRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)                  // Get the user's document
        .collection('projects')       // Access the projects sub-collection
        .doc(projectId);             // Get the specific project document

    // Add community to the project's communities collection
    await projectRef.collection('communities').add(communityData);

    // Optionally update the project document to keep track of communities
    await projectRef.update({
      'communities': FieldValue.arrayUnion([communityData]) // Keep track of created communities
    });

    // Optionally notify listeners for UI updates (if needed)
    // notifyListeners();
  } catch (e) {
    // Handle errors appropriately
    print('Error creating community: $e');
    // Handle or display the error as necessary
  } finally {
    _setLoading(false);
=======
>>>>>>> ahmed
  }
}

}
