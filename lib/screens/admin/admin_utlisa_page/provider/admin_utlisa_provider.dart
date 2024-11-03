import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rifund/screens/admin/admin_utlisa_page/models/userprofile_item_model.dart';

class AdminUtlisaProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to fetch all users from Firestore
 // Method to fetch all users from Firestore
Future<List<CustomUser>> getAllUsers() async {
  try {
    QuerySnapshot querySnapshot = await _firestore.collection('users').get();
    print("Fetched ${querySnapshot.docs.length} users");

    if (querySnapshot.docs.isEmpty) {
      print("Aucun utilisateur trouvé dans Firestore");
      return [];
    }

    return querySnapshot.docs.map((doc) {
      // Cast doc.data() to Map<String, dynamic>
      final data = doc.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('email')) {
        print("User: ${doc.id}, ${data['email']}");
        return CustomUser.fromFirestore(doc);
      } else {
        print("Document ${doc.id} does not have an email field.");
        return null; // Handle missing email field
      }
    }).where((user) => user != null).cast<CustomUser>().toList();
  } catch (e) {
    print("Erreur lors de la récupération des utilisateurs: $e");
    return [];
  }
}

  // Method to accept a user
 // Method to accept a user
Future<void> acceptUser(String uid, BuildContext context) async {
  try {
    await _firestore.collection('users').doc(uid).update({
      'isAccepted': true,
    });
    notifyListeners();
    _showAlertDialog(context, "Succès", "Utilisateur accepté avec succès !");
  } catch (e) {
    print("Error accepting user: $e");
  }
}

// Method to block a user
Future<void> blockUser(String uid, BuildContext context) async {
  try {
    await _firestore.collection('users').doc(uid).update({
      'isBlocked': true,
    });
    notifyListeners();
    _showAlertDialog(context, "Succès", "Utilisateur bloqué avec succès !");
  } catch (e) {
    print("Erreur lors du blocage de l'utilisateur: $e");
  }
}

// Method to delete a user
Future<void> deleteUser(String uid, BuildContext context) async {
  try {
    await _firestore.collection('users').doc(uid).delete();
    print("Utilisateur supprimé avec uid: $uid");
    notifyListeners();
    _showAlertDialog(context, "Succès", "Utilisateur supprimé avec succès !");
  } catch (e) {
    print("Erreur lors de la suppression de l'utilisateur: $e");
  }
}

// Function to show alert dialog
void _showAlertDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


  // Method to
}
