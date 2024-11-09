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
  var name = '';
  var email = '';
  var image = '';

  @override
  void initState() {
    super.initState();
    user_Active();
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
            leading: GestureDetector(
              onTap: () => onTapArrowLeftOne(context),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_outlined,
                    color: Colors.white),
                onPressed: () => onTapArrowLeftOne(context),
              ),
            ),
            centerTitle: true,
            title: AppbarSubtitle(text: "lbl_profile".tr),
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

  // ignore: non_constant_identifier_names
  user_Active() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    await firebaseFirestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .get()
        .then((val) async {
      name = val.data()!['username'].toString();
      email = val.data()!['email'].toString();
      image = val.data()!['image_user'].toString();
    });
    setState(() {});
  }

  Widget _buildName(BuildContext context) {
    return _buildInfoRow(
      label: "Nom :".tr,
      value: name.isEmpty ? 'Nom' : name,
      onTap: () async {
        await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ModifierNomScreen()));
        user_Active();
      },
    );
  }

  Widget _buildEmail(BuildContext context) {
    return _buildInfoRow(
      label: "Email:".tr,
      value: email.isEmpty ? 'xxxxx@gmail.com' : email,
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
                String link = _linkController.text.trim();
                if (link.isNotEmpty) {
                  setState(() {
                    links.add(link);
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }

  Future<String> uploadImageToFirebase(String filePath) async {
    File file = File(filePath);
    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception("Error uploading image: $e");
    }
  }

  Future<void> saveImageUrlToFirestore(String imageUrl) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'image_user': imageUrl,
    });
  }

  void onTapArrowLeftOne(BuildContext context) {
    Navigator.pop(context);
  }
}
