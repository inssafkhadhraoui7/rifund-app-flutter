// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'core/app_export.dart';

// var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   Future.wait([
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
//     PrefUtils().init()
//   ]).then((value) {
//     runApp(MyApp());
//   });
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Sizer(
//       builder: (context, orientation, deviceType) {
//         return ChangeNotifierProvider<ThemeProvider>(
//           create: (context) => ThemeProvider(),
//           child: Consumer<ThemeProvider>(
//             builder: (context, provider, child) {
//               return MaterialApp(
//                 title: 'rifund',
//                 debugShowCheckedModeBanner: false,
//                 theme: theme,
//                 navigatorKey: NavigatorService.navigatorKey,
//                 localizationsDelegates: [
//                   AppLocalizationDelegate(),
//                   GlobalMaterialLocalizations.delegate,
//                   GlobalWidgetsLocalizations.delegate,
//                   GlobalCupertinoLocalizations.delegate
//                 ],
//                 supportedLocales: [Locale('en', '')],
//                 initialRoute: AppRoutes.initialRoute,
//                 routes: AppRoutes.routes,
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }

import 'core/app_export.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
String userId = "";
String projectId = "";
String communityId = "";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  WidgetsFlutterBinding.ensureInitialized();
  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    PrefUtils().init()
  ]).then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeProvider>(
                create: (_) => ThemeProvider()),
            ChangeNotifierProvider<AcceuilClientProvider>(
                create: (_) => AcceuilClientProvider()),
            ChangeNotifierProvider<DetailsProjetProvider>(
                create: (_) => DetailsProjetProvider()),
            ChangeNotifierProvider<AjoutCatGorieProvider>(
                create: (_) => AjoutCatGorieProvider()),
            ChangeNotifierProvider<AppNavigationProvider>(
                create: (_) => AppNavigationProvider()),
            ChangeNotifierProvider<ChatBoxProvider>(
                create: (_) => ChatBoxProvider()),
            ChangeNotifierProvider<CrErCommunautProvider>(
                create: (_) => CrErCommunautProvider()),
            ChangeNotifierProvider<CrErUnCompteProvider>(
                create: (_) => CrErUnCompteProvider()),
            ChangeNotifierProvider<CrErProjetProvider>(
                create: (_) => CrErProjetProvider()),
            ChangeNotifierProvider<FinancerProjetProvider>(
                create: (_) => FinancerProjetProvider()),
            ChangeNotifierProvider<ListeDeCommunautProvider>(
                create: (_) => ListeDeCommunautProvider()),
            ChangeNotifierProvider<ListeDesProjetsProvider>(
                create: (_) => ListeDesProjetsProvider()),
            ChangeNotifierProvider<MembreRejoindreProvider>(
                create: (_) => MembreRejoindreProvider()),
            ChangeNotifierProvider<ModifierMotdepasseProvider>(
                create: (_) => ModifierMotdepasseProvider()),
            ChangeNotifierProvider<ModifierNomProvider>(
                create: (_) => ModifierNomProvider()),
            ChangeNotifierProvider<ModifierProjetProvider>(
                create: (_) => ModifierProjetProvider()),
            ChangeNotifierProvider<MotDePasseOublierProvider>(
                create: (_) => MotDePasseOublierProvider()),
            ChangeNotifierProvider<MotDePasseOublierProvider>(
                create: (_) => MotDePasseOublierProvider()),
            ChangeNotifierProvider<NotificationProvider>(
                create: (_) => NotificationProvider()),
            ChangeNotifierProvider<ProfileProvider>(
                create: (_) => ProfileProvider()),
            ChangeNotifierProvider<SeConnecterProvider>(
                create: (_) => SeConnecterProvider()),
            ChangeNotifierProvider<SplashProvider>(
                create: (_) => SplashProvider()),
            ChangeNotifierProvider<SplashProvider>(
                create: (_) => SplashProvider()),
            ChangeNotifierProvider<WelcomeProvider>(
                create: (_) => WelcomeProvider()),
            ChangeNotifierProvider<AppNavigationProvider1>(
                create: (_) => AppNavigationProvider1()),
            ChangeNotifierProvider<AffichageCommunautProvider>(
                create: (_) =>
                    AffichageCommunautProvider(userId, projectId, communityId)),
            ChangeNotifierProvider<AdminCommunautProvider>(
                create: (_) => AdminCommunautProvider()),
            ChangeNotifierProvider<AdminCategoryProvider>(
                create: (_) => AdminCategoryProvider()),
            ChangeNotifierProvider<AdminProjetProvider>(
                create: (_) => AdminProjetProvider()),
            ChangeNotifierProvider<ProfileAdminProvider>(
                create: (_) => ProfileAdminProvider()),
            ChangeNotifierProvider<AdminUtlisaProvider>(
                create: (_) => AdminUtlisaProvider()),
            ChangeNotifierProvider(create: (_) => AffichageCategorieProvider()),
          ],
          child: Consumer<ThemeProvider>(
            builder: (context, provider, child) {
              return MaterialApp(
                title: 'rifund',
                debugShowCheckedModeBanner: false,
                theme: theme,
                navigatorKey: NavigatorService.navigatorKey,
                localizationsDelegates: const [
                  AppLocalizationDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate
                ],
                supportedLocales: const [Locale('en', '')],
                initialRoute: RoutePath.initialRoute,
                routes: AppRoutes.routes,
              );
            },
          ),
        );
      },
    );
  }
}
