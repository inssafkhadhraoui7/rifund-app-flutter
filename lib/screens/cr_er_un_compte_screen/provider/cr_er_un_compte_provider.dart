import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrErUnCompteProvider extends ChangeNotifier {
  TextEditingController? imageOneController = TextEditingController();
  TextEditingController? emailController = TextEditingController();
  TextEditingController? passwordOneController = TextEditingController();
  TextEditingController? confirmPasswordController = TextEditingController();

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
    try {
      // Firebase authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController!.text,
        password: passwordOneController!.text,
      );

      // Saving user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'nom': imageOneController!.text,
        'email': emailController!.text,
      });

      return ""; // No error
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Une erreur inconnue s'est produite.";
    } catch (e) {
      return "Erreur lors de l'enregistrement des données utilisateur.";
    }
  }
}
