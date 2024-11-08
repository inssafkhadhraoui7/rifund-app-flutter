import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rifund/main.dart';
import 'package:rifund/screens/membre_rejoindre_screen/models/membre_rejoindre_model.dart';
import '../models/userprofile_item_model.dart';

class MembreRejoindreProvider extends ChangeNotifier {
  MembreRejoindreModel membreRejoindreModelObj = MembreRejoindreModel();

Future<void> fetchMembersByCommunity(String communityId, String userId, String projectId) async {
  try {
    final membersSnapshot = await FirebaseFirestore.instance
        .collection('users') // Start at the 'users' collection
        .doc(userId) // Specify the user document
        .collection('projects') // Go to the 'projects' subcollection
        .doc(projectId) // Specify the project document
        .collection('communities') // Go to the 'communities' subcollection
        .doc(communityId) // Specify the community document
        .collection('members') // Query the 'members' collection
        .where('status', isNotEqualTo: 'approved') // Exclude members with 'approved' status
        .get();

    if (membersSnapshot.docs.isEmpty) {
      print("No members found for this community.");
      return;
    }

    // Clear the current list before adding new members
    membreRejoindreModelObj.userprofileItemList.clear();

    for (var memberDoc in membersSnapshot.docs) {
      final memberData = memberDoc.data();
      membreRejoindreModelObj.userprofileItemList.add(
        UserprofileItemModel(
          userImage: memberData['image'] ?? '',
          username: memberData['nom'] ?? '',
          id: memberDoc.id,
        ),
      );
    }

    // Notify listeners to update the UI
    notifyListeners();
  } catch (e) {
    print("Error fetching members: $e");
  }
}

Future<void> approveMember(String memberId, String communityId, String userId, String projectId) async {
  try {
    DocumentSnapshot memberDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('projects')
      .doc(projectId)
      .collection('communities')
      .doc(communityId)
      .collection('members')
      .doc(memberId)
      .get();

    if (memberDoc.exists) {
      // Update member status to 'approved'
      await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('projects')
        .doc(projectId)
        .collection('communities')
        .doc(communityId)
        .collection('members')
        .doc(memberId)
        .update({'status': 'approved'});

      // Remove the approved member from the local list
      membreRejoindreModelObj.userprofileItemList.removeWhere((member) => member.id == memberId);

      // Notify listeners to update the UI
      notifyListeners();

      print("Member approved and removed from list");
    } else {
      print("Member document not found.");
    }
  } catch (e) {
    print("Error approving member: $e");
  }
}


Future<void> rejectMember(String memberId, String communityId, String userId, String projectId) async {
  try {
    // Delete the member from Firestore
    await FirebaseFirestore.instance
      .collection('users')
      .doc(userId) // Assuming userId is set and passed properly
      .collection('projects')
      .doc(projectId) // Assuming projectId is set and passed properly
      .collection('communities')
      .doc(communityId)
      .collection('members')
      .doc(memberId)
      .delete();

    // Remove the member from the local list after successful deletion
    membreRejoindreModelObj.userprofileItemList.removeWhere((member) => member.id == memberId);

    // Notify listeners to update the UI
    notifyListeners();
    print("Member rejected and deleted successfully");
  } catch (e) {
    print("Error rejecting member: $e");
  }
}

}
