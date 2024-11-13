import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rifund/screens/details_projet_screen/details_projet_screen.dart';
import 'package:rifund/screens/listeprojets/listeprojets.dart';

import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/bottomNavBar.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'models/modifier_projet_model.dart';
import 'provider/modifier_projet_provider.dart';

class ModifierProjetScreen extends StatefulWidget {
  const ModifierProjetScreen({super.key});
  
  @override
  ModifierProjetScreenState createState() => ModifierProjetScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ModifierProjetProvider(),
      child: const ModifierProjetScreen(),
    );
  }
}

// ignore_for_file: must_be_immutable
class ModifierProjetScreenState extends State<ModifierProjetScreen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Initialize any necessary data for project modification, if applicable.
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorScheme.onPrimaryContainer,
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 25.v),
              Container(
                margin: EdgeInsets.only(
                  left: 26.h,
                  right: 22.h,
                  bottom: 20.v,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 10.h,
                  vertical: 15.v,
                ),
                decoration: AppDecoration.outlinePrimary1.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 5.v),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(left: 12.h),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 0.h),
                              child: Text(
                                "Remplir les champs que vous devez modifier".tr,
                                style: CustomTextStyles.titleSmallPrimary,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12.v),
                    _buildProjectTitle(context),
                    SizedBox(height: 12.v),
                    _buildDescriptionValue(context),
                    SizedBox(height: 12.v),
                    _buildProjectImages(context),
                    SizedBox(height: 12.v),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildBudgetValueOne(context),
                          Selector<ModifierProjetProvider, ModifierProjetModel?>(
                            selector: (context, provider) => provider.modifierProjetModelObj,
                            builder: (context, modifierProjetModelObj, child) {
                              return CustomDropDown(
                                width: 116.h,
                                icon: Container(
                                  child: CustomImageView(
                                    imagePath: ImageConstant.imgcrprojet,
                                    height: 15.adaptSize,
                                    width: 15.adaptSize,
                                  ),
                                ),
                                hintText: "lbl_devise".tr,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.h,
                                  vertical: 11.v,
                                ),
                                items: modifierProjetModelObj?.dropdownItemList ?? [],
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 12.v),
                    _buildDurationOne(context),
                    SizedBox(height: 12.v),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.h),
                      child: Selector<ModifierProjetProvider, ModifierProjetModel?>(
                        selector: (context, provider) => provider.modifierProjetModelObj,
                        builder: (context, modifierProjetModelObj, child) {
                          return CustomDropDown(
                            icon: Container(
                              child: CustomImageView(
                                imagePath: ImageConstant.imgcrprojet,
                                height: 15.adaptSize,
                                width: 15.adaptSize,
                              ),
                            ),
                            hintText: "lbl_cat_gorie".tr,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.h,
                              vertical: 11.v,
                            ),
                            items: modifierProjetModelObj?.categoryDropdownItemList ?? [],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 12.v),
                    _buildCompteOne(context),
                    SizedBox(height: 12.v),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(left: 50.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _buildModifier(context),
                            _buildAnnuler(context)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
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
            icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
            onPressed: () {
              onTapArrowleftone(context);
            },
          ),
          AppbarTitle(
            text: "Modifier projet".tr,
            margin: EdgeInsets.only(
              left: 80.h,
              top: 2.v,
              right: 79.h,
            ),
          ),
        ],
      ),
      styleType: Style.bgFill_1,
    );
  }

  /// Section Widget for Project Title
  Widget _buildProjectTitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.h),
      child: Selector<ModifierProjetProvider, TextEditingController?>(
        selector: (context, provider) => provider.projectTitleController,
        builder: (context, projectTitleController, child) {
          return CustomTextFormField(
            controller: projectTitleController,
            hintText: "lbl_titre_du_projet".tr,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 11.v,
            ),
          );
        },
      ),
    );
  }

  /// Section Widget for Description
  Widget _buildDescriptionValue(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.h),
      child: Selector<ModifierProjetProvider, TextEditingController?>(
        selector: (context, provider) => provider.descriptionValueController,
        builder: (context, descriptionValueController, child) {
          return CustomTextFormField(
            controller: descriptionValueController,
            hintText: "lbl_description".tr,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 11.v,
            ),
          );
        },
      ),
    );
  }

  /// Section Widget for Project Images
  Widget _buildProjectImages(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.h),
      child: Selector<ModifierProjetProvider, TextEditingController?>(
        selector: (context, provider) => provider.projectImagesController,
        builder: (context, projectImagesController, child) {
          return Stack(
            children: [
              CustomTextFormField(
                controller: projectImagesController,
                hintText: "msg_images_du_projet".tr,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.h,
                  vertical: 11.v,
                ),
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
                      allowMultiple: true,
                    );
                    if (result != null) {
                      List<String> paths =
                          result.paths.map((path) => path!).toList();
                      List<String> fileNames =
                          result.files.map((file) => file.name ?? '').toList();
                      print('Selected images: $paths');
                      print('Selected image names: $fileNames');
                    }
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
                    child: Icon(
                      Icons.add_photo_alternate,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Section Widget for Budget Value
  Widget _buildBudgetValueOne(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.h),
      child: Selector<ModifierProjetProvider, TextEditingController?>(
        selector: (context, provider) => provider.budgetValueOneController,
        builder: (context, budgetValueOneController, child) {
          return CustomTextFormField(
            width: 140.h,
            controller: budgetValueOneController,
            hintText: "lbl_budget".tr,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 11.v,
            ),
          );
        },
      ),
    );
  }

  /// Section Widget for Duration
  Widget _buildDurationOne(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.h),
      child: Selector<ModifierProjetProvider, TextEditingController?>(
        selector: (context, provider) => provider.durationOneController,
        builder: (context, durationOneController, child) {
          return CustomTextFormField(
            controller: durationOneController,
            hintText: "lbl_dur_e".tr,
            textInputAction: TextInputAction.done,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 11.v,
            ),
            suffix: Container(
              padding: EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
              child: Icon(
                Icons.calendar_month,
              ),
            ),
          );
        },
      ),
    );
  }

  /// Section Widget for Current Account Number
  Widget _buildCompteOne(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.h),
      child: Selector<ModifierProjetProvider, TextEditingController?>(
        selector: (context, provider) => provider.comptecourantController,
        builder: (context, dateController, child) {
          return CustomTextFormField(
            controller: dateController,
            hintText: "Numéro du compte courant".tr,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 11.v,
            ),
            textInputAction: TextInputAction.done,
          );
        },
      ),
    );
  }

  /// Handle Modify Project Action
  Widget _buildModifier(BuildContext context) {
    return Center(
      child: CustomElevatedButton(
        height: 36.v,
        width: 114.h,
        text: "lbl_modifier".tr,
        buttonStyle: CustomButtonStyles.fillLightGreen,
        buttonTextStyle: CustomTextStyles.titleSmallOnPrimaryContainer,
        onPressed: () {
          // Perform the modification logic here
          _modifyProject(context);
        },
      ),
    );
  }

  /// Handle Cancel Action
  Widget _buildAnnuler(BuildContext context) {
    return Center(
      child: CustomElevatedButton(
        height: 36.v,
        width: 114.h,
        text: "lbl_annuler".tr,
        margin: EdgeInsets.only(left: 10.h),
        buttonStyle: CustomButtonStyles.fillBlueGray,
        buttonTextStyle: CustomTextStyles.titleSmallBlack900,
        onPressed: () {
          onTapArrowleftone(context);
        },
      ),
    );
  }

  /// Modify Project Logic
  _modifyProject(BuildContext context) {
 
    print("Modifying project...");
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ListeDesProjetsPage()),
    );
  }

  onTapArrowleftone(BuildContext context) {
    NavigatorService.goBack();
  }
}
