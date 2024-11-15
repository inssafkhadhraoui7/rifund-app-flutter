import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/admin_communaut_model.dart';

class AdminCommunautProvider extends ChangeNotifier {
  List<AdminCommunautModel> communities = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch communities from nested collections
  Future<void> fetchCommunities() async {
    try {
      communities.clear(); // Clear current list to avoid duplicates

      // Get all users
      QuerySnapshot usersSnapshot = await _firestore.collection('users').get();
      
      for (var userDoc in usersSnapshot.docs) {
        // For each user, get all projects
        QuerySnapshot projectsSnapshot = await userDoc.reference.collection('projects').get();

        for (var projectDoc in projectsSnapshot.docs) {
          // For each project, get all communities
          QuerySnapshot communitiesSnapshot = await projectDoc.reference.collection('communities').get();

          for (var communityDoc in communitiesSnapshot.docs) {
            // Add the community to the list, utilizing the updated model that includes description and webUrl
            communities.add(AdminCommunautModel.fromDocument(communityDoc)); 
          }
        }
      }

      notifyListeners(); // Update UI after fetching all communities
    } catch (e) {
      print("Error fetching communities: $e");
    }
  }


Future<void> updateCommunityStatus(
  String userId, String projectId, String communityId, bool isValidated, BuildContext context) async {
  try {
    // Validate inputs
    if (userId.isEmpty || projectId.isEmpty || communityId.isEmpty) {
      print("Error: One or more IDs are empty: userId=$userId, projectId=$projectId, communityId=$communityId");
      return; // Early exit if any ID is empty
    }

    // Firestore update logic
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('projects')
        .doc(projectId)
        .collection('communities')
        .doc(communityId)
        .update({'status': isValidated ? 'validated' : 'refused'});

    // If approved, check for bad words
    if (isValidated) {
      bool containsBadWords = await checkForBadWords(communityId);
      
      if (containsBadWords) {
        _showBadWordsAlert(context);
        // Optionally, you can mark the community as refused if bad words are found
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('projects')
            .doc(projectId)
            .collection('communities')
            .doc(communityId)
            .update({'status': 'refused'});

        return; // Early exit if bad words are found
      }

      _showApprovalAlert(context);
    } else {
      // Remove the community from the list if it is refused
      _removeCommunityFromList(communityId);
    }

    // Optionally, refresh data after update
    notifyListeners();
  } catch (e) {
    print("Error updating community status: $e");
  }
}
// Method to show the alert when a community is approved
void _showApprovalAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Approuvé par la communauté"),
        content: Text("Cette communauté a été approuvée avec succès."),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the alert
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}
Future<bool> checkForBadWords(String communityId) async {
  try {
    // Fetch the community data (name or description) from Firestore
    DocumentSnapshot communityDoc = await _firestore.collection('communities').doc(communityId).get();
    
    if (!communityDoc.exists) {
      print("Community not found");
      return false;
    }

    String communityName = communityDoc['name'] ?? '';
    String communityDescription = communityDoc['description'] ?? '';

    // You can send both the name and description to the bad words API
    String textToCheck = communityName + " " + communityDescription;

    // Send a request to the bad words API (replace with the actual API URL)
    final response = await http.post(
      Uri.parse('https://api.checkBadWords.com/check'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({'text': textToCheck}),
    );

    if (response.statusCode == 200) {
      // Parse the response to check for bad words
      var result = json.decode(response.body);
      bool containsBadWords = result['containsBadWords'] ?? false;
      
      return containsBadWords;
    } else {
      print("Failed to check bad words");
      return false;
    }
  } catch (e) {
    print("Error checking for bad words: $e");
    return false;
  }
}

void _showBadWordsAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Community Rejected"),
        content: Text("This community contains offensive language and has been rejected."),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the alert
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}


// Method to remove the community from the list when refused
void _removeCommunityFromList(String communityId) {
  // Safely remove the community from the list
  communities.removeWhere((community) => community.id == communityId);
}

  @override
  void dispose() {
    super.dispose();
  }
}
