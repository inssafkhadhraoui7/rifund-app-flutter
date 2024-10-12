import 'package:flutter/material.dart';

class SeConnecterProvider with ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordoneController = TextEditingController();

  bool isShowPassword = true;

  void changePasswordVisibility() {
    isShowPassword = !isShowPassword;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordoneController.dispose();
    super.dispose();
  }

  void se_connecter_provider(BuildContext context) {}
}
