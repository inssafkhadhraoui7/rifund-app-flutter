import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrErUnCompteProvider extends ChangeNotifier {
  TextEditingController imageOneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordOneController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isShowPassword = true;
  bool isShowPassword1 = true;

  // Method to change the visibility of the password
  void changePasswordVisibility() {
    isShowPassword = !isShowPassword;
    notifyListeners();
  }

  void changePasswordVisibility1() {
    isShowPassword1 = !isShowPassword1;
    notifyListeners();
  }

  Future<String> createUserAccount(BuildContext context) async {
    // Input validation
    if (emailController.text.isEmpty || passwordOneController.text.isEmpty || confirmPasswordController.text.isEmpty || imageOneController.text.isEmpty) {
      return "Tous les champs sont obligatoires.";
    }

    if (passwordOneController.text != confirmPasswordController.text) {
      return "Les mots de passe ne correspondent pas.";
    }

    try {
      // Firebase authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordOneController.text,
      );

      // Saving user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'nom': imageOneController.text, // Ensure this holds the user's name
        'email': emailController.text,
      });

      return ""; // No error
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Une erreur inconnue s'est produite.";
    } catch (e) {
      return "Erreur lors de l'enregistrement des données utilisateur.";
    }
  }
}
