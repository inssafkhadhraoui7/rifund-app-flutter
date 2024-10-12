import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rifund/screens/liste_de_communaut_page/liste_de_communaut_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rifund/screens/se_connecter_screen/se_connecter_screen.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/bottomNavBar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'provider/cr_er_communaut_provider.dart';

class CrErCommunautScreen extends StatelessWidget {
  const CrErCommunautScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CrErCommunautProvider(),
      child: const CrErCommunautScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: Consumer<CrErCommunautProvider>(
          builder: (context, provider, child) {
            return Form(
              key: provider.formKey,
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
                          _buildCreateCommunity(context, provider),
                          SizedBox(height: 16.v),
                          _buildDescriptionValue(context, provider),
                          SizedBox(height: 17.v),
                          _buildWebUrl(context, provider),
                          SizedBox(height: 29.v),
                          Padding(
                            padding: EdgeInsets.only(left: 13.h, right: 18.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildCreateButton(context, provider),
                                _buildCancelButton(context),
                              ],
                            ),
                          ),
                          SizedBox(height: 5.v),
                          if (provider.isLoading) 
                            CircularProgressIndicator(), // Loading indicator
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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
            icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
            onPressed: () {
              NavigatorService.goBack();
            },
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

  Widget _buildCreateCommunity(BuildContext context, CrErCommunautProvider provider) {
    return CustomTextFormField(
      controller: provider.createCommunityController,
      hintText: "msg_cr_er_le_nom_de".tr,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Le nom de la communauté est requis.";
        }
        return null;
      },
      suffix: Container(
        padding: EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
        child: const Icon(Icons.people),
      ),
    );
  }

  Widget _buildDescriptionValue(BuildContext context, CrErCommunautProvider provider) {
    return CustomTextFormField(
      controller: provider.descriptionValueController,
      hintText: "lbl_description".tr,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "La description est requise.";
        }
        return null;
      },
    );
  }

  Widget _buildWebUrl(BuildContext context, CrErCommunautProvider provider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.h),
      child: Selector<CrErCommunautProvider, TextEditingController?>(
        selector: (context, provider) => provider. webUrlController,
        builder: (context,  webUrlController, child) {
          return Column(
            children: [
              Stack(
                children: [
                  CustomTextFormField(
                    controller:  webUrlController,
                    hintText: "image de communauté".tr,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 11.v),
                    readOnly: true,
                    validator: (value) {
                      if (!context.read<CrErCommunautProvider>().isImageSelectionValid()) {
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
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.image,
                          allowMultiple: true,
                        );

                        if (result != null) {
                          List<String> paths = result.paths.map((path) => path!).toList();
                          List<String> names = result.files.map((file) => file.name ?? '').toList();

                          context.read<CrErCommunautProvider>().updateSelectedImages(paths, names);

                           webUrlController!.text = names.join(', ');
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
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

Widget _buildCreateButton(BuildContext context, CrErCommunautProvider provider) {
  return Expanded(
    child: CustomElevatedButton(
      text: "lbl_cr_er".tr,
      height: 36.v,
      width: 117.h,
      margin: EdgeInsets.only(right: 12.h),
      buttonTextStyle: CustomTextStyles.labelLargeWhiteA700,
      onPressed: provider.isLoading ? null : () async {
        // Check if the form is valid
        if (provider.formKey.currentState!.validate()) {
          final String? userId = FirebaseAuth.instance.currentUser?.uid;

          if (userId == null) {
            // Show a notification to the user to log in
         _showDialog(context);
            return;
          }

          final String projectId = "currentProjectId"; // Update as necessary
          final String communityName = provider.createCommunityController.text; // Get the community name from the controller

          // Call the createCommunity method with the community name
          await provider.createCommunity(userId, projectId, communityName);

          // Navigate to another screen if needed
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => ListeDeCommunautPage(),
          ));
        }
      },
    ),
  );
}


  void _showDialog(BuildContext context) {
    // Implementation of your dialog logic
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Title'),
          content: Text('Dialog content goes here.'),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildCancelButton(BuildContext context) {
    return Expanded(
      child: CustomElevatedButton(
        text: "lbl_annuler".tr,
        height: 36.v,
        width: 117.h,
        buttonTextStyle: CustomTextStyles.labelLargeWhiteA700,
        onPressed: () {
          NavigatorService.goBack();
        },
      ),
    );
  }
}
