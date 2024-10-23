import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../communityservice.dart';
import '../models/cr_er_communaut_model.dart';

class CrErCommunautProvider extends ChangeNotifier {
  // Controllers for user input
  TextEditingController createCommunityController = TextEditingController();
  TextEditingController descriptionValueController = TextEditingController();
  TextEditingController webUrlController = TextEditingController();

  // Variables to hold project ID and user ID
  String? projectId; // To hold the project ID for the community
  String? userId;    // To hold the user ID (UID from Firebase Auth)

  // Model for community
  CrErCommunautModel crErCommunautModelObj = CrErCommunautModel();

  // Flag to track if the provider is disposed
  bool _isDisposed = false;

  // Lists to hold selected image paths and names
  List<String> selectedImagePaths = [];
  List<String> selectedImageNames = [];

  // Set the project ID when initializing the provider
  void setProjectId(String id) {
    projectId = id;
    if (!_isDisposed) {
      print('Project ID set in provider: $projectId');
      notifyListeners();
    }
  }

  // Automatically fetch the current user ID from Firebase Auth
  Future<void> fetchUserId() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      print('User ID: $userId');
    } else {
      print('User not authenticated');
      // Handle case where the user is not authenticated if needed
    }
  }

  @override
  void dispose() {
    _isDisposed = true; // Set the disposed flag
    createCommunityController.dispose();
    descriptionValueController.dispose();
    webUrlController.dispose();
    super.dispose();
  }

  // Function to create a community
 Future<void> createCommunity(BuildContext context) async {
  if (_isDisposed) return; // Prevent actions if provider is disposed

  // Ensure user ID is available
  await fetchUserId();

  // Validate inputs
  if (createCommunityController.text.isEmpty ||
      descriptionValueController.text.isEmpty ||
      projectId == null ||
      userId == null ||
      !isImageSelectionValid()) {
    print('Validation error: All fields and IDs must be provided');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill in all fields and try again.')),
    );
    return;
  }

  try {
    // Create community
    await CommunityService().createCommunity(
      name: createCommunityController.text,
      description: descriptionValueController.text,
      webUrl: webUrlController.text.isNotEmpty ? webUrlController.text : null,
      userId: userId!,
      projectId: projectId!,
    );

    if (_isDisposed) return; // Check again post-async operation

    // Clear input fields after successful creation
    _clearInputFields();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Community created successfully!')),
    );

  } catch (e) {
    print('Error creating community: $e');
    if (!_isDisposed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating community: $e')),
      );
    }
  }
}

void _clearInputFields() {
  createCommunityController.clear();
  descriptionValueController.clear();
  webUrlController.clear();
  selectedImagePaths.clear();
  selectedImageNames.clear();
  notifyListeners(); // Notify listeners after clearing
}


  // Function to update selected image
  void updateSelectedImage(String path, String name) {
    selectedImagePaths = [path]; // If only one image is allowed
    selectedImageNames = [name];
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  // Validation for image selection
  bool isImageSelectionValid() {
    return selectedImagePaths.isNotEmpty;
  }
}
