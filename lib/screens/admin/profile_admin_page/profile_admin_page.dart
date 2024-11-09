import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rifund/screens/admin/admin_communaut_screen/admin_communaut_screen.dart';
import 'package:rifund/screens/admin/admin_projet_screen/admin_projet_screen/admin_projet_screen.dart';

import 'package:rifund/screens/admin/admin_utlisa_page/admin_utlisa_page.dart';
import 'package:rifund/screens/profile_screen/provider/profile_provider.dart';

import '../../../core/app_export.dart';
import '../../../widgets/app_bar/appbar_subtitle.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/custom_bottom_bar.dart';
import '../../../widgets/custom_outlined_button.dart';
import '../../modifier_motdepasse_screen/modifier_motdepasse_screen.dart';
import '../../modifier_nom_screen/modifier_nom_screen.dart';
import 'provider/profile_admin_provider.dart';

class ProfileAdminPage extends StatefulWidget {
  const ProfileAdminPage({Key? key}) : super(key: key);

  @override
  ProfileAdminPageState createState() => ProfileAdminPageState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileAdminProvider(),
      child: ProfileAdminPage(),
    );
  }
}

class ProfileAdminPageState extends State<ProfileAdminPage> {


  var name = '';
  var email = '';
  var image = '';
  @override
  void initState() {
    user_Active();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white, // Set background color to white
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              _buildColumnTelevision(context),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.h,
                  vertical: 17.v,
                ),
                child: Column(
                  children: [
                    Text(
                      "msg_information_personnelle".tr,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: 11.v),
                    _buildName(context),
                    _buildEmail(context),
                    _buildMotdepass(context),
                    SizedBox(height: 13.v),
                    CustomOutlinedButton(
                      height: 32.v,
                      width: 192.h,
                      text: "Liste des utilisateurs".tr,
                      buttonTextStyle: CustomTextStyles.titleSmallSemiBold,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminUtlisaPage()),
                        );
                      },
                    ),
                    SizedBox(height: 13.v),
                    CustomOutlinedButton(
                      height: 32.v,
                      width: 192.h,
                      text: "Liste des projets".tr,
                      buttonTextStyle: CustomTextStyles.titleSmallSemiBold,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminProjetScreen()),
                        );
                      },
                    ),
                    SizedBox(height: 13.v),
                    CustomOutlinedButton(
                      height: 32.v,
                      width: 192.h,
                      text: "Liste des communautés".tr,
                      buttonTextStyle: CustomTextStyles.titleSmallSemiBold,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminCommunautScreen()),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }
  user_Active() async{
    FirebaseFirestore  firebaseFirestore =  FirebaseFirestore.instance ;
    FirebaseAuth auth = FirebaseAuth.instance;

    await firebaseFirestore.collection("users").doc(auth.currentUser!.uid).get().then((val) async {
      //    count(int.parse(ahmed.data()!['count']));
      name = val.data()!['username'].toString();
      email = val.data()!['email'].toString();
      image = val.data()!['image_user'].toString();

    });
    setState(() {});
  }

  Widget _buildColumnTelevision(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.v),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15.h),
          bottomRight: Radius.circular(15.h),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomAppBar(
            leadingWidth: 68.h,
            leading: GestureDetector(
              onTap: () {
                onTapArrowLeftOne(context);
              },
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
                onPressed: () {
                  onTapArrowLeftOne(context);
                },
              ),
            ),
            centerTitle: true,
            title: AppbarSubtitle(
              text: "lbl_profile".tr,
            ),
            styleType: Style.bgFill_1,
          ),
          SizedBox(height: 25.v),
          GestureDetector(
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.image,
                allowMultiple: false,
              );

              if (result != null && result.files.single.path != null) {
                String filePath = result.files.single.path!;
                String imageUrl = await uploadImageToFirebase(filePath);


                final profileProvider = Provider.of<ProfileProvider>(context);

                // Update the profile image URL in the provider
                profileProvider.updateProfileImage(imageUrl);

                // Save the image URL to Firestore
                await saveImageUrlToFirestore(imageUrl);
              }
            },
            child: CircleAvatar(
              radius: 50,
              backgroundImage: image.isNotEmpty
                  ? NetworkImage(image)
                  : AssetImage('assets/images/avatar.png') as ImageProvider,
            ),
          ),
          SizedBox(height: 16.v),
          Text(
            "msg_modifier_photo_profile".tr,
            style: CustomTextStyles.titleMediumWhiteA700,
          )
        ],
      ),
    );
  }
  Future<String> uploadImageToFirebase(String filePath) async {
    File file = File(filePath);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString()  ;
    Reference ref = FirebaseStorage.instance.ref().child('users_images/$fileName');
    UploadTask uploadTask = ref.putFile(file);

    await uploadTask.whenComplete(() {});

    String imageUrl = await ref.getDownloadURL();
    return imageUrl;
  }

  Future<void> saveImageUrlToFirestore(String imageUrl) async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    // Ensure the user is signed in
    if (user != null) {
      String uid = user.uid; // Get the user's ID

      try {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'image_user': imageUrl,
        });
        print("Image utilisateur mise à jour avec succès dans Firestore.");
      } catch (e) {
        print("Erreur lors de la mise à jour de l'image utilisateur dans Firestore : $e");
      }
    } else {
      print("Aucun utilisateur n'est actuellement connecté.");
    }
  }
  Widget _buildName(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 3.h),
      padding: EdgeInsets.symmetric(
        horizontal: 15.h,
        vertical: 10.v,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            "Nom :".tr,
            style: theme.textTheme.bodyLarge,
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            name.isEmpty ? 'Nom' : name,
            style: theme.textTheme.bodyLarge,
          ),
          SizedBox(
            width: 95,
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ModifierNomScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmail(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 3.h),
      padding: EdgeInsets.symmetric(
        horizontal: 15.h,
        vertical: 10.v,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Email:".tr,
            style: theme.textTheme.bodyLarge,
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            email.isEmpty ? 'xxxxx@gmail.com' : email,
            style: theme.textTheme.bodyLarge,
          ),
          SizedBox(
            width: 35,
          ),
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildMotdepass(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 3.h),
      padding: EdgeInsets.symmetric(
        horizontal: 15.h,
        vertical: 10.v,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            "Mot de passe :".tr,
            style: theme.textTheme.bodyLarge,
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            "*******".tr,
            style: theme.textTheme.bodyLarge,
          ),
          SizedBox(
            width: 90,
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ModifierMotdepasseScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  void onTapArrowLeftOne(BuildContext context) {}
}
