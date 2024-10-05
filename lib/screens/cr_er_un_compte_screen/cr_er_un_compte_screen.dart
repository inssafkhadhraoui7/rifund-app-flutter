import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Assurez-vous que provider est importé
import 'package:firebase_auth/firebase_auth.dart'; // Importer Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Importer Firestore

import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'provider/cr_er_un_compte_provider.dart';

class CrErUnCompteScreen extends StatefulWidget {
  const CrErUnCompteScreen({Key? key}) : super(key: key);

  @override
  CrErUnCompteScreenState createState() => CrErUnCompteScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CrErUnCompteProvider(),
      child: CrErUnCompteScreen(),
    );
  }
}

class CrErUnCompteScreenState extends State<CrErUnCompteScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: 3.v),
                Expanded(
                  child: Container(
                    child: RepaintBoundary(
                      child: SizedBox(
                        height: 770.v,
                        width: double.infinity,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Positioned(
                              bottom: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 100.h,
                                  vertical: 90.v,
                                ),
                                decoration: AppDecoration.outlineBlack.copyWith(
                                  borderRadius: BorderRadiusStyle.roundedBorder21,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(height: 110.v),
                                    SizedBox(height: 5.v),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 55.v, right: 85.v),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 21.h,
                                  right: 31.h,
                                ),
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

  Widget _buildLoginForm(BuildContext context) {
    return Container(
      width: 300.h,
      margin: EdgeInsets.only(left: 8.h),
      padding: EdgeInsets.symmetric(
        horizontal: 25.h,
        vertical: 40.v,
      ),
      decoration: AppDecoration.fillWhiteA.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "lbl_cr_er_un_compte".tr,
            style: CustomTextStyles.titleLargeExtraBold,
          ),
          SizedBox(height: 34.v),
          _buildImageOne(context),
          SizedBox(height: 27.v),
          _buildEmail(context),
          SizedBox(height: 26.v),
          _buildPasswordOne(context),
          SizedBox(height: 27.v),
          _buildConfirmPassword(context),
          SizedBox(height: 22.v),
          _buildCreateButton(context),
        ],
      ),
    );
  }

  Widget _buildImageOne(BuildContext context) {
    return Selector<CrErUnCompteProvider, TextEditingController?>(
      selector: (context, provider) => provider.imageOneController,
      builder: (context, imageOneController, child) {
        return CustomTextFormField(
          controller: imageOneController,
          hintText: "lbl_nom".tr,
          suffix: Container(
            margin: EdgeInsets.fromLTRB(30.h, 7.v, 10.h, 7.v),
            child: Icon(Icons.person),
            height: 17,
            width: 23,
          ),
          suffixConstraints: BoxConstraints(
            maxHeight: 41.v,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Ce champ ne peut pas être vide".tr; 
            }
            return null; 
          },
        );
      },
    );
  }

  Widget _buildEmail(BuildContext context) {
    return Selector<CrErUnCompteProvider, TextEditingController?>(
      selector: (context, provider) => provider.emailController,
      builder: (context, emailController, child) {
        return CustomTextFormField(
          controller: emailController,
          hintText: "lbl_email".tr,
          textInputType: TextInputType.emailAddress,
          suffix: Container(
            margin: EdgeInsets.fromLTRB(30.h, 7.v, 10.h, 7.v),
            child: Icon(Icons.mail),
            height: 17,
            width: 23,
          ),
          suffixConstraints: BoxConstraints(
            maxHeight: 41.v,
          ),
          validator: (value) {
            if (value == null || !isValidEmail(value, isRequired: true)) {
              return "E-mail invalide".tr;
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildPasswordOne(BuildContext context) {
    return Consumer<CrErUnCompteProvider>(
      builder: (context, provider, child) {
        return CustomTextFormField(
          controller: provider.passwordOneController,
          hintText: "lbl_mot_de_passe2".tr,
          textInputType: TextInputType.visiblePassword,
          suffix: InkWell(
            onTap: () {
              provider.changePasswordVisibility();
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(30.h, 7.v, 10.h, 7.v),
              child: Icon(Icons.lock),
              height: 17,
              width: 23,
            ),
          ),
          suffixConstraints: BoxConstraints(
            maxHeight: 41.v,
          ),
          validator: (value) {
            if (value == null || !isValidPassword(value, isRequired: true)) {
              return "Le mot de passe est vide".tr;
            }
            return null;
          },
          obscureText: provider.isShowPassword,
        );
      },
    );
  }

  Widget _buildConfirmPassword(BuildContext context) {
    return Consumer<CrErUnCompteProvider>(
      builder: (context, provider, child) {
        return CustomTextFormField(
          controller: provider.confirmPasswordController,
          hintText: "msg_confirmer_le_mot".tr,
          textInputAction: TextInputAction.done,
          textInputType: TextInputType.visiblePassword,
          suffix: InkWell(
            onTap: () {
              provider.changePasswordVisibility1();
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(30.h, 7.v, 10.h, 7.v),
              child: Icon(Icons.lock),
              height: 17,
              width: 23,
            ),
          ),
          suffixConstraints: BoxConstraints(
            maxHeight: 41.v,
          ),
          validator: (value) {
            if (value == null || !isValidPassword(value, isRequired: true)) {
              return "Le mot de passe est vide".tr;
            }
            if (value != provider.passwordOneController.text) {
              return "Les mots de passe ne correspondent pas".tr;
            }
            return null;
          },
          obscureText: provider.isShowPassword1,
        );
      },
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return Center(
      child: CustomElevatedButton(
        width: 120.h,
        height: 40.v,
        text: "lbl_cr_er".tr,
        margin: EdgeInsets.only(
          left: 25.h,
          right: 20.h,
        ),
        buttonTextStyle: CustomTextStyles.labelLarge_1,
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Gérer la soumission du formulaire
            onTapCreateButton(context);
          }
        },
        alignment: Alignment.center,
      ),
    );
  }

  void onTapCreateButton(BuildContext context) async {
    final provider = Provider.of<CrErUnCompteProvider>(context, listen: false);
    String name = provider.imageOneController.text; // Récupérer le nom
    String email = provider.emailController.text;
    String password = provider.passwordOneController.text;

    try {
      // Créer un compte utilisateur avec Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Optionnel : stocker des informations supplémentaires sur l'utilisateur dans Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
      });

      // Naviguez vers l'écran de connexion ou un autre écran après la création
      NavigatorService.pushNamed(AppRoutes.seConnecterScreen);
    } catch (e) {
      // Gérer les erreurs
      String errorMessage = 'Une erreur est survenue';
      if (e is FirebaseAuthException) {
        errorMessage = e.message ?? errorMessage;
      }
      // Affichez un message d'erreur à l'utilisateur
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  void onTapImage(BuildContext context) {
    Navigator.pop(context);
  }
}
