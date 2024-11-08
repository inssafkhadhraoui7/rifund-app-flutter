import 'package:flutter/material.dart';
import 'package:rifund/screens/admin/admin_communaut_screen/admin_communaut_screen.dart';
import 'package:rifund/screens/admin/admin_projet_screen/admin_projet_screen/admin_projet_screen.dart';
import 'package:rifund/screens/admin/admin_utlisa_page/admin_utlisa_page.dart';
import 'package:rifund/screens/admin/admin_cat_gorie_screen/admin_cat_gorie_screen.dart';
import 'package:rifund/screens/affichage_par_categorie/affichagecategorie.dart';
import 'package:rifund/screens/auth/auth_wrapper.dart';
import 'package:rifund/screens/main_page/main_page.dart';
import '../screens/acceuil_client_page/acceuil_client_page.dart';
import '../screens/admin/ajout_cat_gorie_page/ajout_cat_gorie_page.dart';
import '../screens/admin/profile_admin_page/profile_admin_page.dart';
import '../screens/cr_er_communaut_screen/cr_er_communaut_screen.dart';
import '../screens/cr_er_un_compte_screen/cr_er_un_compte_screen.dart';
import '../screens/creationprojet/creationprojet.dart';
import '../screens/financer_projet_screen/financer_projet_screen.dart';
import '../screens/liste_de_communaut_page/liste_de_communaut_page.dart';
import '../screens/listeprojets/listeprojets.dart';
import '../screens/membre_rejoindre_screen/membre_rejoindre_screen.dart';
import '../screens/modifier_motdepasse_screen/modifier_motdepasse_screen.dart';
import '../screens/modifier_nom_screen/modifier_nom_screen.dart';
import '../screens/modifierscreen/modifierprojetscreen.dart';
import '../screens/mot_de_passe_oublier_screen/mot_de_passe_oublier_screen.dart';
import '../screens/navigation/app_navigation_screen.dart';
import '../screens/notification_page/notification_page.dart';
import '../screens/profile_screen/profile_screen.dart';
import '../screens/se_connecter_screen/se_connecter_screen.dart';
import '../screens/splash_page/splash_screen.dart';
import '../screens/welcome_screen/welcome_screen.dart';

import '../core/app_export.dart';
part 'route_path.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
        RoutePath.authWrapper: AuthWrapper.builder,
        RoutePath.crProjetScreen: CrErProjetScreen.builder,
        RoutePath.welcomeScreen: WelcomeScreen.builder,
        RoutePath.splashScreen: SplashScreen.builder,
        RoutePath.seConnecterScreen: SeConnecterScreen.builder,
        RoutePath.acceuilClientPage: AcceuilClientPage.builder,
        RoutePath.affichageCategoriePage: AffichageCategoriePage.builder,
        RoutePath.crErUnCompteScreen: CrErUnCompteScreen.builder,
        RoutePath.motDePasseOublierScreen: MotDePasseOublierScreen.builder,
        RoutePath.modifierProjetScreen: ModifierProjetScreen.builder,
        RoutePath.financerProjetScreen: FinancerProjetScreen.builder,
        RoutePath.ajoutCatGoriePage: AjoutCatGoriePage.builder,
        RoutePath.notificationPage: NotificationPage.builder,
        RoutePath.listeDesProjetsPage: ListeDesProjetsPage.builder,
        RoutePath.crErCommunautScreen: (context) =>
            CrErCommunautScreen.builder(context),
        RoutePath.listeDeCommunautPage: (context) =>
            ListeDeCommunautPage.builder(context),
        RoutePath.membreRejoindreScreen:(context) => MembreRejoindreScreen.builder(
          context,
          userId: "",  // You will replace this with actual data
          projectId: "",  // Replace with actual data
          communityId: "",  // Replace with actual data
        ),
        RoutePath.modifierNomScreen: ModifierNomScreen.builder,
        RoutePath.profileScreen: ProfileScreen.builder,
        RoutePath.modifierMotdepasseScreen: ModifierMotdepasseScreen.builder,
        RoutePath.adminCommunautScreen: AdminCommunautScreen.builder,
        RoutePath.adminCatGorieScreen: AdminCategoryScreen.builder,
        RoutePath.adminProjetScreen: AdminProjetScreen.builder,
        RoutePath.adminUtlisaPage: AdminUtlisaPage.builder,
        RoutePath.profileAdminPage: ProfileAdminPage.builder,
        RoutePath.initialRoute: WelcomeScreen.builder,
        RoutePath.appNavigationScreen: AppNavigationScreen.builder,

        RoutePath.mainPage: MainPage.builder,
      };
}

