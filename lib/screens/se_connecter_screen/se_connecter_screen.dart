import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Ajout de FirebaseAuth
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'package:local_auth/error_codes.dart' as auth_error;


class SeConnecterScreen extends StatefulWidget {
  const SeConnecterScreen({super.key});

  @override
  SeConnecterScreenState createState() => SeConnecterScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SeConnecterProvider(),
      child: const SeConnecterScreen(),
    );
  }
}

class SeConnecterScreenState extends State<SeConnecterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final LocalAuthentication _auth = LocalAuthentication();


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
                  child: SizedBox(
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
            icon: const Icon(Icons.arrow_back),
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
                    height: 17,
                    width: 23,
                    child: const Icon(Icons.email),
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
                      height: 17,
                      width: 23,
                      child: const Icon(Icons.lock),
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
            buttonTextStyle: const TextStyle(color: Colors.white),
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
                    child: const Padding(
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
                icon: const Icon(Icons.facebook),
                color: Colors.blue,
                splashColor: Colors.white,
                iconSize: 35,
                onPressed: () {
                  _handleFacebookLogin();
                },
              ),
              IconButton(
                icon: const Icon(Icons.email),
                color: Colors.red,
                iconSize: 35,
                splashColor: Colors.white,
                onPressed: () {
                  _handleGoogleLogin();
                },
              ),
              IconButton(
                icon: const Icon(Icons.fingerprint),
                color: Colors.black,
                iconSize: 35,
                splashColor: Colors.white,
                onPressed: () async{



                  try {
                    final bool didAuthenticate = await _auth.authenticate(localizedReason: 'please_authenticate_complete_request'.tr
                        , options: const AuthenticationOptions(useErrorDialogs: false,stickyAuth: false,biometricOnly: true),
                        // authMessages:   <AuthMessages> [
                        //   AndroidAuthMessages(
                        //     signInTitle: 'oops_biometric_authentication_required'.tr,
                        //   ),
                        //   // IOSAuthMessages(
                        //   //     cancelButton: 'cancel'.tr,
                        //   //     goToSettingsDescription: 'please'.tr +' ' + 'enable'.tr +'Please enable Touch ID.',)
                        // ]

                    );
                    if(didAuthenticate){
                      NavigatorService.pushNamed(RoutePath.acceuilClientPage);

                    }
                    print(didAuthenticate);
                  } on PlatformException catch (e) {
                    if (e.code == auth_error.notAvailable) {
                    } else if (e.code == auth_error.lockedOut || e.code == auth_error.permanentlyLockedOut) {
                    
                    } 
                  }


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
  start_CheckBiometrics() async {
    final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
    final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
  }
  void onTapTxtSinscrire(BuildContext context) {
    NavigatorService.pushNamed(RoutePath.crErUnCompteScreen);
  }

  void onTapImage(BuildContext context) {
    NavigatorService.pushNamed(RoutePath.welcomeScreen);
  }

void onTapSeconnecter(BuildContext context) async {
  final provider = Provider.of<SeConnecterProvider>(context, listen: false);
  final String email = provider.emailController.text.trim();
  final String password = provider.passwordoneController.text.trim();

  if (email == 'admin01@gmail.com') {
    return NavigatorService.pushNamed(RoutePath.profileAdminPage);
  }

  try {
    // Sign in the user with Firebase Authentication
    final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();

      if (!userDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("L'utilisateur n'existe pas.")),
        );
      } else {
        // Cast the document data to a Map<String, dynamic> before accessing fields
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        // Check if the 'isAccepted' field exists and handle accordingly
        bool isAccepted = userData.containsKey('isAccepted') ? userData['isAccepted'] : false;

        // Prevent deletion or modification of 'nom' during the first login
        bool isFirstLogin = !userData.containsKey('nom');  // Assuming 'nom' is required on the first login
        
        if (isFirstLogin) {
          // Handle first login, ensure 'nom' field is not deleted
          if (!userData.containsKey('nom')) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Veuillez remplir votre nom.")),
            );
            return;  // Stop further actions
          }
        }

        if (isAccepted) {
          // Redirect to home page after successful login
          NavigatorService.pushNamed(RoutePath.mainPage);
        } else {
          // Show a dialog if the user is not accepted
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Accès refusé"),
                content: const Text("Votre compte n'a pas été accepté. Veuillez contacter l'administration."),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        }
      }
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Compte invalide")),
      );
    } else if (e.code == 'wrong-password') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mot de passe incorrect")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur de connexion")),
      );
    }
  }
}

  void onTapTxtMotdepasse(BuildContext context) {
    NavigatorService.pushNamed(RoutePath.motDePasseOublierScreen);
  }

  void _handleFacebookLogin() {
    // Logique de connexion avec Facebook
  }

 void _handleGoogleLogin() async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      // User canceled the sign-in
      return;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    if (userCredential.user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();

      if (!userDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("L'utilisateur n'existe pas.")),
        );
      } else {
        NavigatorService.pushNamed(RoutePath.mainPage);
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Erreur de connexion avec Google")),
    );
  }
}


  @override
  void initState() {
    super.initState();
    start_CheckBiometrics();
  }
}


