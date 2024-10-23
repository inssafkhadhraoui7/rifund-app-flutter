import 'package:flutter/material.dart';

<<<<<<< HEAD
class SeConnecterProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordoneController = TextEditingController();
  TextEditingController nomController = TextEditingController(); // Controller for 'Nom'
=======
class SeConnecterProvider with ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordoneController = TextEditingController();
>>>>>>> ahmed

  bool isShowPassword = true;

  void changePasswordVisibility() {
    isShowPassword = !isShowPassword;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordoneController.dispose();
<<<<<<< HEAD
    nomController.dispose(); // Dispose of the controller
=======
>>>>>>> ahmed
    super.dispose();
  }

  void se_connecter_provider(BuildContext context) {}
}