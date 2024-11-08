import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rifund/screens/liste_de_communaut_page/liste_de_communaut_page.dart';
import 'package:rifund/screens/listeprojets/listeprojets.dart';
import 'package:rifund/screens/modifier_nom_screen/modifier_nom_screen.dart';
import 'package:rifund/screens/modifier_motdepasse_screen/modifier_motdepasse_screen.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileProvider(),
      child: const ProfileScreen(),
    );
  }
}

class ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  final TextEditingController _linkController = TextEditingController();
  List<String> links = [];

  @override
  void initState() {
    super.initState();
    // Fetch user profile data when the screen is initialized
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    profileProvider
        .fetchUserProfileData(); // This should set the profileImageUrl
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildColumnTelevision(context, profileProvider),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.h, vertical: 15.v),
                  child: Column(
                    children: [
                      Text(
                        "msg_information_personnelle".tr,
                        style: theme.textTheme.headlineSmall,
                      ),
                      SizedBox(height: 11.v),
                      _buildName(context),
                      _buildEmail(context),
                      _buildLinks(context),
                      _buildBio(context),
                      SizedBox(height: 13.v),
                      CustomOutlinedButton(
                        height: 32.v,
                        width: 192.h,
                        text: "msg_liste_des_projets".tr,
                        buttonTextStyle: CustomTextStyles.titleSmallSemiBold,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ListeDesProjetsPage()),
                          );
                        },
                      ),
                      SizedBox(height: 13.v),
                      CustomOutlinedButton(
                        height: 32.v,
                        width: 192.h,
                        text: "msg_liste_des_communaut".tr,
                        buttonTextStyle: CustomTextStyles.titleSmallSemiBold,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListeDeCommunautPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColumnTelevision(
      BuildContext context, ProfileProvider profileProvider) {
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
            centerTitle: true,
            title: AppbarSubtitle(text: "lbl_profile".tr),
            styleType: Style.bgFill_1,
          ),
          SizedBox(height: 10.v),
          GestureDetector(
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.image,
                allowMultiple: false,
              );

              if (result != null && result.files.single.path != null) {
                String filePath = result.files.single.path!;
                String imageUrl = await uploadImageToFirebase(filePath);

                profileProvider.updateProfileImage(imageUrl);

                await saveImageUrlToFirestore(imageUrl);
              }
            },
            child: CircleAvatar(
              radius: 50,
              backgroundImage: profileProvider.profileImageUrl.isNotEmpty
                  ? NetworkImage(profileProvider.profileImageUrl)
                  : const AssetImage('assets/images/avatar.png')
                      as ImageProvider,
            ),
          ),
          SizedBox(height: 16.v),
          Text(
            "msg_modifier_photo_profile".tr,
            style: CustomTextStyles.titleMediumWhiteA700,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage(ProfileProvider profileProvider) {
    return CircleAvatar(
      radius: 40,
      backgroundImage: profileProvider.profileImageUrl.isNotEmpty
          ? NetworkImage(profileProvider.profileImageUrl)
          : const AssetImage('assets/avatar.png')
              as ImageProvider, // Use a default image
    );
  }

  Widget _buildName(BuildContext context) {
    return _buildInfoRow(
      label: "Nom :".tr,
      value: "imen missaoui".tr,
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ModifierNomScreen()));
      },
    );
  }

  Widget _buildEmail(BuildContext context) {
    return _buildInfoRow(
      label: "Email:".tr,
      value: "imenmissaoui08@gmail.com".tr,
    );
  }

  Widget _buildLinks(BuildContext context) {
    return Container(
      width: 327.h,
      margin: EdgeInsets.only(right: 3.h),
      padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 10.v),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text("Liens :".tr, style: theme.textTheme.bodyLarge),
              const SizedBox(width: 55),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: links
                      .map((link) =>
                          Text(link, style: theme.textTheme.bodyLarge))
                      .toList(),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 110),
              Text("lbl_ajouter_lien".tr, style: theme.textTheme.bodyMedium),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.black),
                onPressed: () {
                  _showAddLinkDialog(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBio(BuildContext context) {
    return _buildInfoRow(
      label: "lbl_mot_de_passe".tr,
      value: "••••••••••".tr,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ModifierMotdepasseScreen()));
      },
    );
  }

  Widget _buildInfoRow(
      {required String label, required String value, void Function()? onTap}) {
    return Container(
      margin: EdgeInsets.only(right: 3.h),
      padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 10.v),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyLarge),
          const SizedBox(width: 20),
          Text(value, style: theme.textTheme.bodyLarge),
          if (onTap != null)
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Colors.black),
              onPressed: onTap,
            ),
        ],
      ),
    );
  }

  void _showAddLinkDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ajouter un lien"),
          content: TextField(
            controller: _linkController,
            decoration: const InputDecoration(hintText: "Entrez l'URL du lien"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                String link = _linkController.text;
                if (_isValidUrl(link)) {
                  setState(() {
                    links.add(link);
                  });
                  _linkController.clear();
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Lien invalide. Veuillez entrer une URL valide."),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }

  bool _isValidUrl(String url) {
    final Uri? uri = Uri.tryParse(url);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  Future<String> uploadImageToFirebase(String filePath) async {
    File file = File(filePath);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref =
        FirebaseStorage.instance.ref().child('users_images/$fileName');
    UploadTask uploadTask = ref.putFile(file);

    await uploadTask.whenComplete(() {});

    String imageUrl = await ref.getDownloadURL();
    return imageUrl;
  }

  Future<void> saveImageUrlToFirestore(String imageUrl) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;

      try {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'image_user': imageUrl,
        });
        log("Image utilisateur mise à jour avec succès dans Firestore.");
      } catch (e) {
        log("Erreur lors de la mise à jour de l'image utilisateur dans Firestore : $e");
      }
    } else {
      log("Aucun utilisateur n'est actuellement connecté.");
    }
  }

  onTapArrowLeftOne(BuildContext context) {
    Navigator.of(context).pop();
  }
}
