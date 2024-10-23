import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/bottomNavBar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'provider/cr_er_communaut_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class CrErCommunautScreen extends StatefulWidget {
  final String projectId;

  const CrErCommunautScreen({Key? key, required this.projectId}) : super(key: key);

  @override
  CrErCommunautScreenState createState() => CrErCommunautScreenState();

  static Widget builder(BuildContext context) {
    final projectId = ModalRoute.of(context)?.settings.arguments as String?;
    
    if (projectId == null || projectId.isEmpty) {
      return const Center(child: Text('Project ID is missing!'));
    }

    return ChangeNotifierProvider(
      create: (context) {
        final provider = CrErCommunautProvider();
        provider.setProjectId(projectId); // Set the project ID in the provider
        return provider;
      },
      child: CrErCommunautScreen(projectId: projectId),
    );
  }
}




class CrErCommunautScreenState extends State<CrErCommunautScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false; // Track loading state

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
                SizedBox(height: 54.v),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.h,
                    vertical: 33.v,
                  ),
                  decoration: AppDecoration.outlineLightGreen.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 34.v),
                      SizedBox(
                        width: 156.h,
                        child: Text(
                          "msg_cr_er_communaut".tr,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall,
                        ),
                      ),
                      SizedBox(height: 20.v),
                      _buildCreateCommunity(context),
                      SizedBox(height: 16.v),
                      _buildDescriptionValue(context),
                      SizedBox(height: 17.v),
                      _buildWebUrl(context),
                      SizedBox(height: 29.v),
                      Padding(
                        padding: EdgeInsets.only(left: 13.h, right: 18.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildCreateButton(context),
                            _buildCancelButton(context),
                          ],
                        ),
                      ),
                      SizedBox(height: 5.v)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      centerTitle: true,
      title: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          AppbarTitle(
            text: "Créer Communauté".tr,
            margin: EdgeInsets.only(
              left: 50.h,
              top: 2.v,
              right: 60.h,
            ),
          ),
        ],
      ),
      styleType: Style.bgFill_1,
    );
  }

  Widget _buildCreateCommunity(BuildContext context) {
    return Selector<CrErCommunautProvider, TextEditingController?>( 
      selector: (context, provider) => provider.createCommunityController,
      builder: (context, createCommunityController, child) {
        return CustomTextFormField(
          controller: createCommunityController,
          hintText: "msg_cr_er_le_nom_de".tr,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Le nom de la communauté est requis.";
            }
            return null;
          },
          suffix: Container(
            padding: EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
            child: Icon(Icons.people),
          ),
        );
      },
    );
  }

  Widget _buildDescriptionValue(BuildContext context) {
    return Selector<CrErCommunautProvider, TextEditingController?>( 
      selector: (context, provider) => provider.descriptionValueController,
      builder: (context, descriptionValueController, child) {
        return CustomTextFormField(
          controller: descriptionValueController,
          hintText: "lbl_description".tr,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "La description est requise.";
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildWebUrl(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.h),
      child: Selector<CrErCommunautProvider, TextEditingController?>( 
        selector: (context, provider) => provider.webUrlController,
        builder: (context, webUrlController, child) {
          return Column(
            children: [
              Stack(
                children: [
                  CustomTextFormField(
                    controller: webUrlController,
                    hintText: "Sélectionner images".tr,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.h, vertical: 11.v),
                    readOnly: true,
                    validator: (value) {
                      if (!context
                          .read<CrErCommunautProvider>()
                          .isImageSelectionValid()) {
                        return 'Veuillez sélectionner une image.';
                      }
                      return null;
                    },
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.image,
                          allowMultiple: false, // Set to true if you want multiple images
                        );

                        if (result != null && result.paths.isNotEmpty) {
                          String path = result.paths.first!; // Get the first selected image path
                          String name = result.files.first.name; // Get the name of the first image

                          // Update selected image paths and names in the provider
                          context
                              .read<CrErCommunautProvider>()
                              .updateSelectedImage(path, name);

                          // Update the text field with the image file name
                          webUrlController!.text = name;
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.v, horizontal: 10.h),
                        child: Icon(Icons.add_photo_alternate),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.v),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return Expanded(
      child: CustomElevatedButton(
        text: _isLoading ? "Uploading..." : "lbl_cr_er".tr,
        height: 36.v,
        width: 117.h,
        margin: EdgeInsets.only(right: 12.h),
        buttonTextStyle: CustomTextStyles.labelLargeWhiteA700,
        onPressed: _isLoading ? null : () {
          if (_formKey.currentState!.validate()) {
            setState(() {
              _isLoading = true; // Start loading state
            });
            Provider.of<CrErCommunautProvider>(context, listen: false)
                .createCommunity(context)
                .then((_) {
                  setState(() {
                    _isLoading = false; // Stop loading state
                  });
                  Navigator.pop(context); // Navigate back after community creation
                }).catchError((error) {
                  setState(() {
                    _isLoading = false; // Stop loading state on error
                  });
                  // Handle error appropriately (e.g., show a snackbar)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $error')),
                  );
                });
          }
        },
      ),
    );
  }

  Future<String> _uploadImage(String imagePath) async {
    File file = File(imagePath);
    String fileName = path.basename(file.path);
    Reference ref = FirebaseStorage.instance.ref().child("community_images/$fileName");

    // Uploading the file
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snapshot = await uploadTask;

    // Getting the download URL
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Widget _buildCancelButton(BuildContext context) {
    return Expanded(
      child: CustomElevatedButton(
        text: "Annuler".tr,
        height: 36.v,
        width: 117.h,
        margin: EdgeInsets.only(left: 12.h),
        buttonTextStyle: CustomTextStyles.labelLargeBlack900,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
