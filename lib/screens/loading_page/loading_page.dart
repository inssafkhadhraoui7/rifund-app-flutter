import 'dart:async';

import 'package:lottie/lottie.dart';

import '../../core/app_export.dart';
import '../creationprojet/creationprojet.dart';

// ignore: camel_case_types
class loadingscreen extends StatefulWidget {
  const loadingscreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _loadingScreenState createState() => _loadingScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SplashProvider(),
      child: const loadingscreen(),
    );
  }
}

// ignore: camel_case_types
class _loadingScreenState extends State<loadingscreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const CrErProjetScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.lightGreen600,
      body: Center(
        child: Lottie.network(
            'https://lottie.host/f3825b57-3f94-4c82-9b17-07a7e653ee68/BqLwRiX0So.json'),
      ),
    );
  }
}
