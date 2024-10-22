import 'package:flutter/material.dart';

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
  }

  @override
  void dispose() {
    createCommunityController.dispose();
    descriptionValueController.dispose();
    webUrlController.dispose();
    super.dispose();
  }
}
