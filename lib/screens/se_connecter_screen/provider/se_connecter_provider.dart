import 'package:flutter/material.dart';

class SeConnecterProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordoneController = TextEditingController();
  TextEditingController nomController = TextEditingController(); // Controller for 'Nom'

  bool isShowPassword = true;

  void changePasswordVisibility() {
    isShowPassword = !isShowPassword;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordoneController.dispose();
    nomController.dispose(); // Dispose of the controller
    super.dispose();
  }
}
