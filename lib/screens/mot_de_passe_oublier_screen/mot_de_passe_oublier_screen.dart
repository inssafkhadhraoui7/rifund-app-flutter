import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart'; // Assurez-vous d'importer Provider pour le changement d'état.

import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'provider/mot_de_passe_oublier_provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Assurez-vous d'importer Firebase Auth.

class MotDePasseOublierScreen extends StatefulWidget {
  const MotDePasseOublierScreen({Key? key}) : super(key: key);

  @override
  MotDePasseOublierScreenState createState() => MotDePasseOublierScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MotDePasseOublierProvider(),
      child: MotDePasseOublierScreen(),
    );
  }
}

class MotDePasseOublierScreenState extends State<MotDePasseOublierScreen> {
  final _formKey = GlobalKey<FormState>(); // Ajouter la clé du formulaire pour gérer l'état du formulaire.

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        appBar: _buildAppBar(context),
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            horizontal: 20.h,
            vertical: 10.v,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "msg_mot_de_passe_oubli2".tr,
                  style: CustomTextStyles.titleLargeExtraBold,
                ),
              ),
              SizedBox(height: 20.v),
              Container(
                margin: EdgeInsets.only(
                  left: 17,
                  right: 40,
                ),
                child: Text(
                  "Entrez votre email pour recevoir un mot de passe de réinitialisation par email.",
                  overflow: TextOverflow.visible,
                  style: CustomTextStyles.bodyMediumLight,
                ),
              ),
              SizedBox(height: 28.v),
              _buildLoginForm(context),
              SizedBox(height: 5.v),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      centerTitle: true,
      title: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              onTapImage(context);
            },
          ),
          AppbarTitle(
            text: "",
            margin: EdgeInsets.only(
              left: 50.h,
              top: 2.v,
              right: 60.h,
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildLoginForm(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 5.h),
      padding: EdgeInsets.symmetric(
        horizontal: 17.h,
        vertical: 22.v,
      ),
      decoration: AppDecoration.outlineLightGreen.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: Form(
        key: _formKey, // Utilisez la clé du formulaire pour gérer la validation.
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 47.v),
            Container(
              child: Selector<MotDePasseOublierProvider, TextEditingController?>( // Utilisation de Provider pour le contrôle du texte.
                selector: (context, provider) => provider.emailController,
                builder: (context, emailController, child) {
                  return CustomTextFormField(
                    controller: emailController,
                    hintText: "lbl_email".tr,
                    suffix: Container(
                      margin: EdgeInsets.fromLTRB(30.h, 7.v, 10.h, 7.v),
                      child: Icon(Icons.mail),
                      height: 17,
                      width: 23,
                    ),
                    suffixConstraints: BoxConstraints(
                      maxHeight: 50.v,
                    ),
                    contentPadding: EdgeInsets.only(
                      left: 14.h,
                      top: 17.v,
                      bottom: 17.v,
                    ),
                    // Ajouter la validation
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer un email".tr;
                      }
                      if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                        return "Adresse email invalide".tr;
                      }
                      return null;
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 20.v),
            CustomElevatedButton(
              width: 100.h,
              height: 40.v,
              text: "lbl_envoyer".tr,
              buttonTextStyle: theme.textTheme.labelLarge!,
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  // Envoyer l'e-mail de réinitialisation du mot de passe
                  String email = Provider.of<MotDePasseOublierProvider>(context, listen: false).emailController.text;
                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                    // Affiche un message de succès
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Un e-mail de réinitialisation a été envoyé à votre adresse e-mail.")),
                    );
                  } catch (e) {
                    // Gérer les erreurs ici
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Erreur lors de l'envoi de l'e-mail.")),
                    );
                  }
                }
              },
            ),
            SizedBox(height: 50.v),
            Text(
              "msg_vous_avez_d_j_un".tr,
              style: theme.textTheme.titleSmall,
            ),
            SizedBox(height: 7.v),
            GestureDetector(
              onTap: () {
                onTapTxtSeconnecter(context);
              },
              child: Text(
                "lbl_se_connecter".tr,
                style: CustomTextStyles.titleSmallLightgreen600,
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Navigue vers l'écran précédent lorsque l'action est déclenchée.
  void onTapImage(BuildContext context) {
    NavigatorService.goBack();
  }

  /// Navigue vers seConnecterScreen lorsque l'action est déclenchée.
  void onTapTxtSeconnecter(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.seConnecterScreen);
  }
}
