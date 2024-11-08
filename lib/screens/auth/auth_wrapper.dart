import 'package:firebase_auth/firebase_auth.dart';
import 'package:rifund/screens/auth/providers/auth_provider.dart';
import 'package:rifund/core/app_export.dart';

import '../welcome_screen/welcome_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthenticationProvider(),
      child: const AuthWrapper(),
    );
  }
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Error while connecting to Firebase : ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamed(context, RoutePath.mainPage);
            });

            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const WelcomeScreen();
          }
        });
  }
}
