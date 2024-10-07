import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Ajout de FirebaseAuth
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'provider/se_connecter_provider.dart';

class SeConnecterScreen extends StatefulWidget {
  const SeConnecterScreen({Key? key}) : super(key: key);

  @override
  SeConnecterScreenState createState() => SeConnecterScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SeConnecterProvider(),
      child: SeConnecterScreen(),
    );
  }
}

class SeConnecterScreenState extends State<SeConnecterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: Form(
          key: _formKey,
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                SizedBox(height: 5.v),
                Expanded(
                  child: Container(
                    child: SizedBox(
                      width: double.maxFinite,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 70.h, vertical: 50.v),
                              decoration: AppDecoration.outlineBlack.copyWith(
                                borderRadius: BorderRadiusStyle.roundedBorder21,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 170.v),
                                  Text(
                                    "msg_vous_n_avez_pas".tr,
                                    style: CustomTextStyles.titleSmallWhiteA700,
                                  ),
                                  SizedBox(height: 5.v),
                                  GestureDetector(
                                    onTap: () {
                                      onTapTxtSinscrire(context);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 60.v, right: 90.v),
                                      child: Text(
                                        "lbl_s_inscrire".tr,
                                        style: CustomTextStyles.titleSmallbBlackA700,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: EdgeInsets.only(left: 21.h, right: 31.h),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 17.v),
                                  CustomImageView(
                                    imagePath: ImageConstant.imgFigma2RemovebgPreview,
                                    height: 80.v,
                                    width: 80.h,
                                  ),
                                  SizedBox(height: 30.v),
                                  _buildLoginForm(context)
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

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
            margin: EdgeInsets.only(left: 50.h, right: 60.h),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 17.h, vertical: 20.v),
      decoration: AppDecoration.fillWhiteA.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "lbl_bienvenue".tr,
            style: theme.textTheme.headlineMedium,
          ),
          SizedBox(height: 31.v),

          // Email field with validation
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 17.h),
            child: Selector<SeConnecterProvider, TextEditingController?>(
              selector: (context, provider) => provider.emailController,
              builder: (context, emailController, child) {
                return CustomTextFormField(
                  controller: emailController,
                  hintText: "Nom d'utilisateur".tr,
                  suffix: Container(
                    margin: EdgeInsets.fromLTRB(30.h, 12.v, 13.h, 11.v),
                    child: Icon(Icons.email),
                    height: 17,
                    width: 23,
                  ),
                  suffixConstraints: BoxConstraints(maxHeight: 50.v),
                  contentPadding: EdgeInsets.only(left: 14.h, top: 17.v, bottom: 17.v),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "L'email est requis".tr;
                    } else if (!isValidEmail(value)) {
                      return "Veuillez entrer un email valide".tr;
                    }
                    return null;
                  },
                );
              },
            ),
          ),
          SizedBox(height: 12.v),

          // Password field
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 17.h),
            child: Consumer<SeConnecterProvider>(
              builder: (context, provider, child) {
                return CustomTextFormField(
                  controller: provider.passwordoneController,
                  hintText: "lbl_mot_de_passe".tr,
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.visiblePassword,
                  suffix: InkWell(
                    onTap: () {
                      provider.changePasswordVisibility();
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(30.h, 13.v, 13.h, 10.v),
                      child: Icon(Icons.lock),
                      height: 17,
                      width: 23,
                    ),
                  ),
                  suffixConstraints: BoxConstraints(maxHeight: 50.v),
                  obscureText: provider.isShowPassword,
                  contentPadding: EdgeInsets.only(left: 14.h, top: 17.v, bottom: 17.v),
                  validator: (value) {
                    if (value == null || !isValidPassword(value, isRequired: true)) {
                      return "Mot de passe invalide".tr;
                    }
                    return null;
                  },
                );
              },
            ),
          ),
          SizedBox(height: 12.v),

          // Login button
          CustomElevatedButton(
            alignment: Alignment.center,
            width: 120.h,
            height: 40.v,
            buttonTextStyle: TextStyle(color: Colors.white),
            text: "lbl_se_connecter".tr,
            margin: EdgeInsets.only(left: 25.h, right: 20.h),
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                onTapSeconnecter(context);
              }
            },
          ),
          SizedBox(height: 9.v),
          GestureDetector(
            onTap: () {
              onTapTxtMotdepasse(context);
            },
            child: Text(
              "msg_mot_de_passe_oubli".tr,
              style: CustomTextStyles.bodyMediumLight,
            ),
          ),
          SizedBox(height: 13.v),
          SizedBox(
            height: 15.v,
            width: 264.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 264.h,
                    child: Padding(
                      padding: EdgeInsets.only(top: 25.0),
                      child: Divider(),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "lbl_ou".tr,
                    style: CustomTextStyles.labelLargeBlack900,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 5.v),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.facebook),
                color: Colors.blue,
                splashColor: Colors.white,
                iconSize: 35,
                onPressed: () {
                  _handleFacebookLogin();
                },
              ),
              IconButton(
                icon: Icon(Icons.email),
                color: Colors.red,
                iconSize: 35,
                splashColor: Colors.white,
                onPressed: () {
                  _handleGoogleLogin();
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  // Helper function for validating email
  bool isValidEmail(String email) {
    final RegExp regex = RegExp(
      r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return regex.hasMatch(email);
  }

  void onTapTxtSinscrire(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.crErUnCompteScreen);
  }

  void onTapImage(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.welcomeScreen);
  }

  void onTapSeconnecter(BuildContext context) async {
    final provider = Provider.of<SeConnecterProvider>(context, listen: false);
    final String email = provider.emailController?.text.trim() ?? '';
    final String password = provider.passwordoneController?.text.trim() ?? '';

    try {
      // Vérifier si l'utilisateur existe avec le nom d'utilisateur saisi
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        // Rediriger vers la page d'accueil si les informations d'identification sont correctes
        NavigatorService.pushNamed(AppRoutes.acceuilClientPage);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Afficher le message si le compte est invalide
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Compte invalide")),
        );
      } else if (e.code == 'wrong-password') {
        // Afficher le message si le mot de passe est incorrect
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Mot de passe incorrect")),
        );
      } else {
        // Pour tout autre type d'erreur, afficher un message d'erreur générique
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur de connexion")),
        );
      }
    }
  }

  void onTapTxtMotdepasse(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.motDePasseOublierScreen);
  }

  void _handleFacebookLogin() {
    // Logique de connexion avec Facebook
  }

  void _handleGoogleLogin() {
    // Logique de connexion avec Google
  }
}
